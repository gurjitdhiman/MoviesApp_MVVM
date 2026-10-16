//
//  MovieActionButtons.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieActionButtons: View {

    @Binding var isInWatchlist: Bool
    var onWatchTrailer: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onWatchTrailer) {
                Label("Watch Trailer", systemImage: "play.fill")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .foregroundStyle(Color.movieBackground)
                    .background(Color.primary)
                    .clipShape(Capsule())
            }

            Button {
                isInWatchlist.toggle()
            } label: {
                Label(
                    isInWatchlist ? "Added" : "Watchlist",
                    systemImage: isInWatchlist ? "bookmark.fill" : "bookmark"
                )
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .foregroundStyle(Color.primary)
                .background(Color.movieSecondaryBackground)
                .clipShape(Capsule())
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }
}
