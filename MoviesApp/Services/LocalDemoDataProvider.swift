//
//  LocalDemoDataProvider.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Foundation
import Combine

class LocalDemoDataProvider {
    
    static func getDemoMovies() async throws(NetworkError) -> [Movie] {
        let movies = Self.demoMoviesString.data(using: .utf8)!
        do {
            let movieresponse = try JSONDecoder().decode(MovieResponse.self, from: movies)
            return movieresponse.movies
        } catch {
            print(error)
            throw .decodingError
        }
    }
    
    static func getDemoMovieDetail() async throws(NetworkError) -> MovieDetail {
        let movie = Self.movieDetailString.data(using: .utf8)!
        do {
            return try JSONDecoder().decode(MovieDetail.self, from: movie)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    static let demoMoviesString = """
        {
            "Search":\(LocalDemoDataProvider.moviesArrayString),
            "totalResults":"10",
            "Response":"True"
        }
        """
    static let moviesArrayString = """
        [
          {
            "Title": "Batman Begins",
            "Year": "2005",
            "imdbID": "tt0372784",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BMzA2NDQzZDEtNDU5Ni00YTlkLTg2OWEtYmQwM2Y1YTBjMjFjXkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg"
          },
          {
            "Title": "The Batman",
            "Year": "2022",
            "imdbID": "tt1877830",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BMmU5NGJlMzAtMGNmOC00YjJjLTgyMzUtNjAyYmE4Njg5YWMyXkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg"
          },
          {
            "Title": "Batman v Superman: Dawn of Justice",
            "Year": "2016",
            "imdbID": "tt2975590",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BZTJkYjdmYjYtOGMyNC00ZGU1LThkY2ItYTc1OTVlMmE2YWY1XkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg"
          },
          {
            "Title": "Batman",
            "Year": "1989",
            "imdbID": "tt0096895",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BYzZmZWViM2EtNzhlMi00NzBlLWE0MWEtZDFjMjk3YjIyNTBhXkEyXkFqcGc@._V1_SX300.jpg"
          },
          {
            "Title": "Batman Returns",
            "Year": "1992",
            "imdbID": "tt0103776",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BZTliMDVkYTktZDdlMS00NTAwLWJhNzYtMWIwMDZjN2ViMGFiXkEyXkFqcGc@._V1_SX300.jpg"
          },
          {
            "Title": "Batman & Robin",
            "Year": "1997",
            "imdbID": "tt0118688",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BYzU3ZjE3M2UtM2E4Ni00MDI5LTkyZGUtOTFkMGIyYjNjZGU3XkEyXkFqcGc@._V1_SX300.jpg"
          },
          {
            "Title": "Batman Forever",
            "Year": "1995",
            "imdbID": "tt0112462",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BMTUyNjJhZWItMTZkNS00NDc4LTllNjUtYTg3NjczMzA5ZTViXkEyXkFqcGc@._V1_SX300.jpg"
          },
          {
            "Title": "The Lego Batman Movie",
            "Year": "2017",
            "imdbID": "tt4116284",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BMTcyNTEyOTY0M15BMl5BanBnXkFtZTgwOTAyNzU3MDI@._V1_SX300.jpg"
          },
          {
            "Title": "Batman: The Animated Series",
            "Year": "1992–1995",
            "imdbID": "tt0103359",
            "Type": "series",
            "Poster": "https://m.media-amazon.com/images/M/MV5BYjgwZWUzMzUtYTFkNi00MzM0LWFkMWUtMDViMjMxNGIxNDUxXkEyXkFqcGc@._V1_SX300.jpg"
          },
          {
            "Title": "Batman v Superman: Dawn of Justice (Ultimate Edition)",
            "Year": "2016",
            "imdbID": "tt18689424",
            "Type": "movie",
            "Poster": "https://m.media-amazon.com/images/M/MV5BOTRlNWQwM2ItNjkyZC00MGI3LThkYjktZmE5N2FlMzcyNTIyXkEyXkFqcGdeQXVyMTEyNzgwMDUw._V1_SX300.jpg"
          }
        ]
        """
    
    static let movieDetailString = """
        {
          "imdbID": "tt0372784",
          "Title": "Batman Begins",
          "Year": "2005",
          "Rated": "PG-13",
          "Released": "15 Jun 2005",
          "Runtime": "140 min",
          "Genre": "Action, Crime, Drama",
          "Director": "Christopher Nolan",
          "Writer": "Bob Kane, David S. Goyer, Christopher Nolan",
          "Actors": "Christian Bale, Michael Caine, Ken Watanabe",
          "Plot": "After witnessing his parents' death, billionaire Bruce Wayne learns the art of fighting to confront injustice. When he returns to Gotham as Batman, he must stop a secret society that intends to destroy the city.",
          "Language": "English, Mandarin",
          "Country": "United States, United Kingdom",
          "Awards": "Nominated for 1 Oscar. 15 wins & 79 nominations total",
          "Poster": "https://m.media-amazon.com/images/M/MV5BMzA2NDQzZDEtNDU5Ni00YTlkLTg2OWEtYmQwM2Y1YTBjMjFjXkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg",
          "Ratings": [
            {
              "Source": "Internet Movie Database",
              "Value": "8.2/10"
            },
            {
              "Source": "Rotten Tomatoes",
              "Value": "85%"
            },
            {
              "Source": "Metacritic",
              "Value": "70/100"
            }
          ],
          "Metascore": "70",
          "imdbRating": "8.2",
          "imdbVotes": "1,709,629",
          "Type": "movie",
          "DVD": "N/A",
          "BoxOffice": "$206,863,479",
          "Production": "N/A",
          "Website": "N/A",
          "Response": "True"
        }
        """
}

