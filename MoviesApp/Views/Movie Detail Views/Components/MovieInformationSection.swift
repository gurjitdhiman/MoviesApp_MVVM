//
//  MovieInformationSection.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieInformationSection: View {

    let movie: MovieInformationData

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            URLImage(url: movie.poster)
                .aspectRatio(contentMode: .fill)
                .frame(width: 112, height: 166)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 12) {
                Text(movie.title)
                    .font(.title2.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(
                    "\(movie.year)  •  " +
                    "\(movie.rated)  •  " +
                    "\(movie.runtime)"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Text(movie.genre)
                    .font(.subheadline)
                    .foregroundStyle(Color.primary.opacity(0.8))

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)

                    Text(movie.displayRating)
                        .font(.headline)

                    Text("/ 10")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(movie.formattedVotes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MovieInformationSection(movie: MovieInformationData(
        poster: "",
        title: "Batman Begins",
        year: "2005",
        rated: "PG-13",
        runtime: "140 min",
        genre: "Action, Crime, Drama",
        displayRating: "8.2",
        formattedVotes: "1,709,629 votes"
    ))
}
