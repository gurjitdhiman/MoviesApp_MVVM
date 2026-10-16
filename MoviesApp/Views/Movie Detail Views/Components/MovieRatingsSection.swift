//
//  MovieRatingsSection.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieRatingsSection: View {

    let ratings: [MovieRatingData]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ratings")
                .font(.title3.bold())
                .padding(.horizontal, 20)

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(
                        ratings
                    ) { rating in
                        VStack(spacing: 10) {
                            Image(systemName: ratingIcon(for: rating.source))
                                .font(.title2)
                                .foregroundStyle(.yellow)

                            Text(rating.value)
                                .font(.headline)
                                .foregroundStyle(Color.primary)

                            Text(rating.source)
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(width: 116, height: 100)
                        .background(Color.movieSecondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
    }

    private func ratingIcon(for source: String) -> String {
        if source.localizedCaseInsensitiveContains("tomato") {
            return "chart.bar.fill"
        }

        if source.localizedCaseInsensitiveContains("metacritic") {
            return "gauge.with.dots.needle.67percent"
        }

        return "star.fill"
    }
}

#Preview {
    MovieRatingsSection(ratings: [
        MovieRatingData(source: "IMDb", value: "8.2/10"),
        MovieRatingData(source: "Rotten Tomatoes", value: "85%"),
        MovieRatingData(source: "Metacritic", value: "70/100")
    ])
}
