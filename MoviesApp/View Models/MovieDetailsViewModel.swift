//
//  MovieDetailsViewModel.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Combine

@MainActor
final class MovieDetailsViewModel: ViewModelBase {

    @Published var movieDetails: MovieDetail?

    private let httpClient: HTTPClient

    init(
        movieDetails: MovieDetail? = nil,
        httpClient: HTTPClient = .init()
    ) {
        self.movieDetails = movieDetails
        self.httpClient = httpClient
    }

    func getMovieDetailsByIMBDId(imdbID: String) async {
        loadingState = .loading

        do {
            movieDetails = try await httpClient
                .getMoviewDetailsByIMBDID(imdbID)
//            try? await Task.sleep(for: .seconds(3))
            loadingState = .success
        } catch {
            print("Failed to load movie details: \(error)")
            loadingState = .failure
        }
    }

    // MARK: - Basic Information

    var title: String {
        movieDetails?.title ?? "Movie Details"
    }

    var year: String {
        movieDetails?.year ?? ""
    }

    var rated: String {
        movieDetails?.rated ?? ""
    }

    var released: String {
        movieDetails?.released ?? ""
    }

    var runtime: String {
        movieDetails?.runtime ?? ""
    }

    var genre: String {
        movieDetails?.genre ?? ""
    }

    var poster: String {
        movieDetails?.poster ?? ""
    }

    var plot: String {
        movieDetails?.plot ?? "No plot information available."
    }

    // MARK: - Credits

    var director: String {
        movieDetails?.director ?? "N/A"
    }

    var writer: String {
        movieDetails?.writer ?? "N/A"
    }

    var actors: String {
        movieDetails?.actors ?? "N/A"
    }

    // MARK: - Ratings

    var imdbRating: Double {
        Double(movieDetails?.imdbRating ?? "0") ?? 0
    }

    var imdbVotes: String {
        movieDetails?.imdbVotes ?? "N/A"
    }

    var metascore: String {
        movieDetails?.metascore ?? "N/A"
    }

    // MARK: - Additional Details

    var language: String {
        movieDetails?.language ?? "N/A"
    }

    var country: String {
        movieDetails?.country ?? "N/A"
    }

    var awards: String {
        movieDetails?.awards ?? "N/A"
    }

    var boxOffice: String {
        movieDetails?.boxOffice ?? "N/A"
    }

    var production: String {
        movieDetails?.production ?? "N/A"
    }

    var displayRating: String {
        String(format: "%.1f", imdbRating)
    }

    var formattedVotes: String {
        imdbVotes == "N/A" ? imdbVotes : "\(imdbVotes) votes"
    }

    var information: MovieInformationData {
        MovieInformationData(
            poster: poster,
            title: title,
            year: year,
            rated: rated,
            runtime: runtime,
            genre: genre,
            displayRating: displayRating,
            formattedVotes: formattedVotes
        )
    }

    var ratings: [MovieRatingData] {
        movieDetails?.ratings?.map {
            MovieRatingData(
                source: $0.source ?? "Unknown",
                value: $0.value ?? "N/A"
            )
        } ?? [
            MovieRatingData(source: "IMDb", value: "\(imdbRating)/10"),
            MovieRatingData(source: "Rotten Tomatoes", value: "N/A"),
            MovieRatingData(source: "Metacritic", value: metascore)
        ]
    }

    var metadataRows: [MovieDetailRowData] {
        [
            .init(icon: "calendar", title: "Released", value: released),
            .init(icon: "clock", title: "Runtime", value: runtime),
            .init(icon: "checkmark.seal", title: "Rated", value: rated),
            .init(icon: "square.grid.2x2", title: "Genre", value: genre),
            .init(icon: "globe", title: "Language", value: language),
            .init(icon: "mappin.and.ellipse", title: "Country", value: country),
            .init(icon: "trophy", title: "Awards", value: awards),
            .init(icon: "banknote", title: "Box Office", value: boxOffice),
            .init(icon: "film", title: "Production", value: production),
            .init(icon: "chart.bar", title: "Metascore", value: metascore)
        ]
    }

    var creditRows: [MovieDetailRowData] {
        [
            .init(icon: "person", title: "Director", value: director),
            .init(icon: "pencil", title: "Writer", value: writer),
            .init(icon: "person.2", title: "Cast", value: actors)
        ]
    }
}

struct MovieInformationData {
    let poster: String
    let title: String
    let year: String
    let rated: String
    let runtime: String
    let genre: String
    let displayRating: String
    let formattedVotes: String
}

struct MovieRatingData: Identifiable {
    let source: String
    let value: String

    var id: String { source }
}

struct MovieDetailRowData: Identifiable {
    let icon: String
    let title: String
    let value: String

    var id: String { title }
}
