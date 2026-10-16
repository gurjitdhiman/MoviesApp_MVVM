//
//  ImageCachePolicy.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 12/10/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Foundation
import CryptoKit
import os

// MARK: - Policy & errors

enum ImageCachePolicy {
    /// Memory -> disk -> network. Fresh downloads are stored.
    case useCache
    /// Skip reading the cache, download, and overwrite the cached copy.
    case refresh
    /// Skip reading AND writing the cache. Always a one-off download.
    case ignoreCache
}

enum ImageCacheError: Error {
    case invalidURL
    case badResponse(Int)
    case emptyData
}

// MARK: - ImageCache

/// Thread-safe image cache.
///
/// - Two layers: `NSCache` (memory) and a folder in `Caches/` (disk).
/// - Each entry expires after `defaultMaxAge` (30 days by default),
///   or after a per-call `maxAge`.
/// - Concurrent requests for the same URL share ONE network download.
/// - `clearAll()` wipes memory + disk and invalidates in-flight downloads.
actor ImageCache {

    static let shared = ImageCache()

    /// 30 days
    static let defaultTimeToLive: TimeInterval = 30 * 24 * 60 * 60

    // MARK: Configuration

    /// Default time limit for every cache entry. Can be changed at any time:
    /// `ImageCache.shared.defaultMaxAge = 7 * 24 * 60 * 60`
    nonisolated var defaultMaxAge: TimeInterval {
        get { maxAgeLock.withLock { $0 } }
        set { maxAgeLock.withLock { $0 = newValue } }
    }

    // MARK: State

    private final class Entry {
        let data: Data
        let storedAt: Date
        init(data: Data, storedAt: Date) {
            self.data = data
            self.storedAt = storedAt
        }
    }

    private struct InFlight {
        let id: UUID
        let task: Task<Data, Error>
    }

    // NSCache is itself thread-safe, so it's safe to expose a
    // synchronous, nonisolated memory lookup (used to avoid placeholder flashes).
    private nonisolated(unsafe) let memory = NSCache<NSString, Entry>()
    private nonisolated let maxAgeLock: OSAllocatedUnfairLock<TimeInterval>

    private let directory: URL
    private let session: URLSession
    private var inFlight: [String: InFlight] = [:]
    private var generation = 0   // bumped by clearAll() so stale downloads don't re-fill the cache

    // MARK: Init

    init(
        directoryName: String = "ImageCache",
        defaultMaxAge: TimeInterval = ImageCache.defaultTimeToLive,
        session: URLSession? = nil
    ) {
        self.maxAgeLock = OSAllocatedUnfairLock(initialState: defaultMaxAge)

        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.directory = base.appendingPathComponent(directoryName, isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        if let session {
            self.session = session
        } else {
            // No URLCache: we manage caching ourselves, avoid double caching.
            let config = URLSessionConfiguration.default
            config.urlCache = nil
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            self.session = URLSession(configuration: config)
        }

        memory.totalCostLimit = 100 * 1024 * 1024   // ~100 MB in memory
    }

    // MARK: Public API

    /// Returns image data for the URL.
    /// - Parameters:
    ///   - policy: how to treat the cache (see `ImageCachePolicy`).
    ///   - maxAge: overrides `defaultMaxAge` for this call's freshness check.
    func data(
        for urlString: String,
        policy: ImageCachePolicy = .useCache,
        maxAge: TimeInterval? = nil
    ) async throws -> Data {

        guard let url = URL(string: urlString) else {
            throw ImageCacheError.invalidURL
        }

        // One-off download: no cache read, no cache write, no sharing.
        if policy == .ignoreCache {
            return try await Self.download(url, session: session)
        }

        let key = Self.key(for: urlString)
        let ttl = maxAge ?? defaultMaxAge

        if policy == .useCache, let cached = cachedData(forKey: key, maxAge: ttl) {
            return cached
        }

        // Same image already downloading -> join it instead of starting another.
        if let running = inFlight[key] {
            return try await running.task.value
        }

        let id = UUID()
        let startGeneration = generation
        let session = self.session

        // Unstructured task: it keeps running (and fills the cache) even if
        // the caller that started it is cancelled.
        let task = Task<Data, Error> {
            do {
                let data = try await Self.download(url, session: session)
                self.complete(key: key, id: id, data: data, generation: startGeneration)
                return data
            } catch {
                self.complete(key: key, id: id, data: nil, generation: startGeneration)
                throw error
            }
        }
        inFlight[key] = InFlight(id: id, task: task)

        return try await task.value
    }

    /// Synchronous memory-only lookup. Lets a view show an already-cached
    /// image on its very first frame (important for zoom transitions).
    nonisolated func cachedMemoryData(for urlString: String, maxAge: TimeInterval? = nil) -> Data? {
        let key = Self.key(for: urlString)
        guard let entry = memory.object(forKey: key as NSString) else { return nil }
        let ttl = maxAge ?? defaultMaxAge
        return Date().timeIntervalSince(entry.storedAt) <= ttl ? entry.data : nil
    }

    /// Forcefully removes EVERYTHING (memory + disk) and invalidates downloads
    /// that are currently running, so they won't write into the cache afterwards.
    func clearAll() {
        generation += 1
        inFlight.removeAll()
        memory.removeAllObjects()
        try? FileManager.default.removeItem(at: directory)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    /// Removes the cached copy of a single image.
    func removeCachedImage(for urlString: String) {
        let key = Self.key(for: urlString)
        memory.removeObject(forKey: key as NSString)
        try? FileManager.default.removeItem(at: fileURL(for: key))
    }

    /// Deletes expired files from disk (call e.g. at app launch).
    /// Memory entries expire lazily on lookup.
    func purgeExpired(maxAge: TimeInterval? = nil) {
        let ttl = maxAge ?? defaultMaxAge
        let keys: [URLResourceKey] = [.contentModificationDateKey]

        guard let files = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: keys
        ) else { return }

        let now = Date()
        for file in files {
            let date = (try? file.resourceValues(forKeys: Set(keys)))?.contentModificationDate
            if date == nil || now.timeIntervalSince(date!) > ttl {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }

    // MARK: Private

    private func complete(key: String, id: UUID, data: Data?, generation: Int) {
        if inFlight[key]?.id == id {
            inFlight[key] = nil
        }
        // Don't store results that started before a clearAll().
        if let data, generation == self.generation {
            store(data, forKey: key)
        }
    }

    private func store(_ data: Data, forKey key: String) {
        memory.setObject(
            Entry(data: data, storedAt: Date()),
            forKey: key as NSString,
            cost: data.count
        )
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try? data.write(to: fileURL(for: key), options: .atomic)
    }

    private func cachedData(forKey key: String, maxAge: TimeInterval) -> Data? {
        let now = Date()

        // 1. Memory
        if let entry = memory.object(forKey: key as NSString) {
            if now.timeIntervalSince(entry.storedAt) <= maxAge {
                return entry.data
            }
            memory.removeObject(forKey: key as NSString)
        }

        // 2. Disk (file modification date == time it was stored)
        let file = fileURL(for: key)
        guard let storedAt = (try? file.resourceValues(forKeys: [.contentModificationDateKey]))?
            .contentModificationDate else { return nil }

        guard now.timeIntervalSince(storedAt) <= maxAge,
              let data = try? Data(contentsOf: file) else {
            try? FileManager.default.removeItem(at: file)   // expired / unreadable
            return nil
        }

        memory.setObject(
            Entry(data: data, storedAt: storedAt),
            forKey: key as NSString,
            cost: data.count
        )
        return data
    }

    private func fileURL(for key: String) -> URL {
        directory.appendingPathComponent(key, isDirectory: false)
    }

    private static func key(for urlString: String) -> String {
        SHA256.hash(data: Data(urlString.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
    }

    private static func download(_ url: URL, session: URLSession) async throws -> Data {
        let (data, response) = try await session.data(from: url)

        if let http = response as? HTTPURLResponse,
           !(200..<300).contains(http.statusCode) {
            throw ImageCacheError.badResponse(http.statusCode)
        }
        guard !data.isEmpty else { throw ImageCacheError.emptyData }
        return data
    }
}
