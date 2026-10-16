//
//  Movie.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
    let movies: [Movie]
    let totalResults: String
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults = "totalResults"
    }
}

struct Movie: Codable, Identifiable {
    
    let title : String
    let year : String
    let imdbID : String
    let type : String
    let poster : String
    
    var id: String { imdbID }
    
    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        year = try values.decode(String.self, forKey: .year)
        imdbID = try values.decode(String.self, forKey: .imdbID)
        type = try values.decode(String.self, forKey: .type)
        poster = try values.decode(String.self, forKey: .poster)
    }
    
    static var demoMovies: [Movie] {
        let moviesData = LocalDemoDataProvider.moviesArrayString.data(using: .utf8) ?? Data()
        return try! JSONDecoder().decode([Movie].self, from: moviesData)
    }
    
    static var demoMovie: Movie {
        let moviesData = LocalDemoDataProvider.moviesArrayString.data(using: .utf8) ?? Data()
        return try! JSONDecoder().decode([Movie].self, from: moviesData).randomElement()!
    }
}

