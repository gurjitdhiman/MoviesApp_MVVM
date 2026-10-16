//
//  MovieCreditsSection.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieCreditsSection: View {

    let rows: [MovieDetailRowData]

    var body: some View {
        VStack(spacing: 18) {
            Divider()
                .overlay(Color.primary.opacity(0.15))

            ForEach(rows) { row in
                MetadataRow(icon: row.icon, title: row.title, value: row.value)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MovieCreditsSection(rows: [
        MovieDetailRowData(icon: "person", title: "Director", value: "Christopher Nolan"),
        MovieDetailRowData(icon: "pencil", title: "Writer", value: "David S. Goyer"),
        MovieDetailRowData(icon: "person.2", title: "Cast", value: "Christian Bale")
    ])
}
