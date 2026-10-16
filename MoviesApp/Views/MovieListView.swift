//
//  MovieListView.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieListView: View {

    @Namespace private var transitionNamespace
    
    @SwiftUI.Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @SwiftUI.Environment(\.verticalSizeClass) private var verticalSizeClass

    private var isIPhoneLandscape: Bool {
        UIDevice.current.userInterfaceIdiom == .phone &&
        verticalSizeClass == .compact
    }

    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private var cellsSpacing: CGFloat {
        18
    }

    var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    let moviesVMs: [MovieViewModel]

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: gridColumns(),
                spacing: cellsSpacing
            ) {
                ForEach(moviesVMs) { movieVM in

                        NavigationLink {
                            MovieDetailsScreen(
                                imdbID: movieVM.imdbID,
                                poster: movieVM.poster,
                                title: movieVM.title
                            )
                            .navigationTransition(
                                .zoom(
                                    sourceID: movieVM.imdbID,
                                    in: transitionNamespace
                                )
                            )
                        } label: {
                            MovieCard(movieVM: movieVM)
                                .matchedTransitionSource(
                                    id: movieVM.imdbID,
                                    in: transitionNamespace
                                ) { source in
                                    source.clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                                        
                                }
                                
                        }
                        .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, cellsSpacing)
        }
    }

    private func gridColumns() -> [GridItem] {
        if isCompact && !isIPhoneLandscape {
            return [
                GridItem(.flexible(), spacing: cellsSpacing),
                GridItem(.flexible())
            ]
        } else {
            return [
                GridItem(.adaptive(minimum: 180), spacing: cellsSpacing)
            ]
        }
    }
}

#Preview {
//    MovieCard(movieVM: MovieViewModel(movie: Movie.demoMovie))
    MovieListView(moviesVMs: Movie.demoMovies.map(MovieViewModel.init))
}

