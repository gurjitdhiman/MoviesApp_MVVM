//
//  ImageLoader.swift
//  URLImageDemo
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - ImageLoader

@MainActor
final class ImageLoader: ObservableObject {

    @Published var downloadedData: Data?
    @Published var image: UIImage?

    private let cache: ImageCache
    private var currentURL: String?
    private var task: Task<Void, Never>?

    /// Pass `url` to show an already-cached image on the very first frame.
    init(url: String? = nil, maxAge: TimeInterval? = nil, cache: ImageCache = .shared) {
        self.cache = cache
        if let url {
            currentURL = url
            if let data = cache.cachedMemoryData(for: url, maxAge: maxAge),
               let uiImage = UIImage(data: data) {
                downloadedData = data
                image = uiImage
            }
        }
    }

    /// Fire-and-forget version (same call shape as your old ImageLoader).
    func downloadImage(
        url: String,
        policy: ImageCachePolicy = .useCache,
        maxAge: TimeInterval? = nil
    ) {
        task?.cancel()
        task = Task { await load(url: url, policy: policy, maxAge: maxAge) }
    }

    /// Async version, used by `URLImage`'s `.task`.
    func load(
        url: String,
        policy: ImageCachePolicy = .useCache,
        maxAge: TimeInterval? = nil
    ) async {
        // URL changed -> drop the old image so it doesn't show for the new URL.
        if currentURL != url {
            currentURL = url
            image = nil
            downloadedData = nil
        }

        // Instant path: already in memory.
        if policy == .useCache, image != nil { return }

        do {
            let data = try await cache.data(for: url, policy: policy, maxAge: maxAge)
            guard !Task.isCancelled, currentURL == url,
                  let uiImage = UIImage(data: data) else { return }
            downloadedData = data
            image = uiImage
        } catch {
            // Keep placeholder on failure.
        }
    }
}

// MARK: - URLImage
