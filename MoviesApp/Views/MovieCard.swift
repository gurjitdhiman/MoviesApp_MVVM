//
//  MovieCard.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieCard: View {

    let movieVM: MovieViewModel

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            URLImage(url: movieVM.poster)
                .aspectRatio(
                    2.0 / 3.0,
                    contentMode: .fit
                )
                .frame(maxWidth: .infinity)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

            Text(movieVM.title)
                .font(.headline)
                .lineLimit(2)

            Text(movieVM.year)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    @Previewable @Namespace var ns
    MovieCard(movieVM: MovieViewModel(movie: Movie.demoMovie))
}
