//
//  MovieMetadataSection.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MovieMetadataSection: View {

    let rows: [MovieDetailRowData]

    var body: some View {
        VStack(spacing: 18) {
            ForEach(rows) { row in
                MetadataRow(icon: row.icon, title: row.title, value: row.value)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MovieMetadataSection(rows: [
        MovieDetailRowData(icon: "calendar", title: "Released", value: "15 Jun 2005"),
        MovieDetailRowData(icon: "clock", title: "Runtime", value: "140 min")
    ])
}
