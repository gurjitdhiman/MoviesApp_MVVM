//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieDetailsView: View {

    let movieDetailsViewModel: MovieDetailsViewModel
    @State private var showNavigationTitle = false
    @State private var isInWatchlist = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                MovieHeroSection(
                    poster: movieDetailsViewModel.poster,
                    title: movieDetailsViewModel.title,
                    year: movieDetailsViewModel.year,
                    rated: movieDetailsViewModel.rated,
                    runtime: movieDetailsViewModel.runtime,
                    genre: movieDetailsViewModel.genre
                )
                MovieInformationSection(movie: movieDetailsViewModel.information)
                MovieRatingsSection(ratings: movieDetailsViewModel.ratings)
                MovieActionButtons(isInWatchlist: $isInWatchlist)
                MoviePlotSection(plot: movieDetailsViewModel.plot)
                MovieMetadataSection(rows: movieDetailsViewModel.metadataRows)
                MovieCreditsSection(rows: movieDetailsViewModel.creditRows)
            }
            .padding(.bottom, 32)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.movieBackground.ignoresSafeArea())
        .foregroundStyle(Color.primary)
        .scrollIndicators(.hidden)
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y
        } action: { _, offsetY in
            showNavigationTitle = offsetY > 250
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.none, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(showNavigationTitle ? movieDetailsViewModel.title : "")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isInWatchlist.toggle()
                } label: {
                    Image(systemName: isInWatchlist ? "heart.fill" : "heart")
                        .foregroundStyle(isInWatchlist ? .pink : .primary)
                }
            }
        }
    }
}

#Preview {
    MovieDetailsView(movieDetailsViewModel: .init(movieDetails: MovieDetail.demo))
}
