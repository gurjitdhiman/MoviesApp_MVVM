//
//  MovieHeroSection.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieHeroSection: View {

    let poster: String?
    var title: String
    var year: String = ""
    var rated: String = ""
    var runtime: String = ""
    var genre: String = " "
    var height: CGFloat = 430

    private var subtitle: String {
        let subtitles = [year, rated, runtime]
        if subtitles.allSatisfy({$0.isEmptyOrWhitespace}) { return " " }
        
        return subtitles
            .filter { !$0.isEmptyOrWhitespace }
            .joined(separator: "  •  ")
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                URLImage(url: poster)
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .top
                    )
                    .clipped()

                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.1),
                        .init(color: .black.opacity(0.35), location: 0.45),
                        .init(color: .black.opacity(0.85), location: 0.75),
                        .init(color: .black, location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    Text(genre)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .clipped()
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipped()
    }
}

#Preview {
    MovieHeroSection(poster: "https://images.unsplash.com/photo-1485846234645-a62644f84728?ixid=M3w4MjcwNjd8MHwxfHNlYXJjaHwxfHxGaWxtfGVufDB8fHx8MTc5MjEzNDgzNHww&ixlib=rb-4.1.0&w=900&h=1600&fit=max&q=80", title: "Action")
}
