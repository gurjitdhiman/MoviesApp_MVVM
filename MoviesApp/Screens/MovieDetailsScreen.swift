//
//  MovieDetailsScreen.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieDetailsScreen: View {
    let imdbID: String
    let poster: String?
    let title: String
    
    @StateObject private var viewModel = MovieDetailsViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .success:
                MovieDetailsView(
                    movieDetailsViewModel: viewModel
                )
            case .none, .loading:
                VStack(spacing: 16) {
                    MovieHeroSection(poster: poster, title: title)
                    //                    .overlay { ProgressView() }
                    ProgressView()
                    Spacer()
                }
            case .failure:
                FailedView(message: "Something went wrong while loading movies. Please try again.")
            }
        }.onAppear {
            Task {
                await viewModel.getMovieDetailsByIMBDId(imdbID: imdbID)
            }
        }
        .ignoresSafeArea(.container, edges: .vertical)
    }
}

