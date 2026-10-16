//
//  MovieURL+Extentions.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Foundation

extension URL {
    
    static func forMovieDetails(_ id: String)-> URL? {
        // Create movie detail -> https://www.omdbapi.com/?i=MOVIEimdbID&apikey=APIKEY
        
        guard var urlComponents = URLComponents(string: Constants.ApiBaseURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "i", value: id),
            URLQueryItem(name: "apikey", value: Constants.API_KEY)
        ]
        
        return urlComponents.url
    }
    
    static func forMoviesByName(_ name: String)-> URL? {
        // Create search movies call URL like -> https://www.omdbapi.com/?s=MOVIEkeyworD&apikey=APIKEY
        
        guard var urlComponents = URLComponents(string: "https://www.omdbapi.com/") else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "s", value: name),
            URLQueryItem(name: "apikey", value: Constants.API_KEY)
        ]
        
        return urlComponents.url
    }
}
