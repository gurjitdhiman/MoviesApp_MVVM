//
//  MoviesListViewModel.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Combine
import Foundation

@MainActor
class MoviesListViewModel: ViewModelBase {
    
    @Published var movies: [MovieViewModel] = .init()
    
    private var httpClient = HTTPClient()
    
    func searchByName(_ name: String) async {
        if name.isEmptyOrWhitespace {
            return
        }
        loadingState = .loading
        
        do {
            let movies = try await httpClient.getMovies(by: name)
            self.movies = movies.map(MovieViewModel.init)
            self.loadingState = .success
        } catch let error {
            print(error)
            loadingState = .failure
        }
        
    }
}

struct MovieViewModel: Identifiable {
    var id: String { movie.imdbID }
    let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        movie.title
    }
    
    var year: String {
        movie.year
    }
    
    var imdbID: String {
        movie.imdbID
    }
    
    var type: String {
        movie.type
    }
    
    var poster: String {
        movie.poster
    }
    
}
