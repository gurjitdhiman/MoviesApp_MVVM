//
//  MovieListScreen.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieListScreen: View {

    @StateObject private var movieListViewModel = MoviesListViewModel()

    @State private var movieName = ""

    var body: some View {
        NavigationStack {
            VStack {
                switch movieListViewModel.loadingState {
                case .none:
                    ContentUnavailableView {
                        Label("Find a Movie", systemImage: "magnifyingglass")
                    } description: {
                        Text("Use the search field above to search for movies by name or keywords.")
                    }
                case .success:
                    MovieListView(
                        moviesVMs: movieListViewModel.movies
                    )
                case .loading:
                    ProgressView()
                    Spacer()
                case .failure:
                    FailedView()
                }
            }
            .searchable(
                text: $movieName,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search movies"
            )
            .modifier(MovieSearchToolbarModifier())
            .onSubmit(of: .search) {
                Task {
                    await movieListViewModel.searchByName(movieName)
                }
            }
            .navigationTitle(Text("Movies"))
        }
    }
}

#Preview {
    MovieListScreen()
}

struct MovieSearchToolbarModifier: ViewModifier {

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .toolbar {
                    DefaultToolbarItem(
                        kind: .search,
                        placement: .navigation
                    )
                }
        } else {
            content
        }
    }
}
