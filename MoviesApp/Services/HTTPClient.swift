//
//  HTTPClient.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

class HTTPClient {
    
    func getMovies(by search: String) async throws(NetworkError) -> [Movie] {
        if Constants.ENVIRONMENT == .local {
            return try await LocalDemoDataProvider.getDemoMovies()
        }
        
        guard let url = URL.forMoviesByName(search) else {
            throw .badURL
        }

        let response: MovieResponse = try await fetch(from: url)
        return response.movies
    }
    
    func getMoviewDetailsByIMBDID(_ imdbID: String) async throws(NetworkError) -> MovieDetail {
        if Constants.ENVIRONMENT == .local {
            return try await LocalDemoDataProvider.getDemoMovieDetail()
        }
        
        guard let url = URL.forMovieDetails(imdbID) else {
            throw .badURL
        }
        return try await fetch(from: url)
        
    }
    
    private func fetch<T: Decodable>(from url: URL) async throws(NetworkError) -> T {
        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch let error {
            print(error)
            throw .noData
        }

        guard !data.isEmpty else {
            throw .noData
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw .decodingError
        }
    }
    
}
