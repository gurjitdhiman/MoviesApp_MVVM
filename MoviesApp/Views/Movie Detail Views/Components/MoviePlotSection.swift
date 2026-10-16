//
//  MoviePlotSection.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MoviePlotSection: View {

    let plot: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Plot")
                .font(.title2.bold())
                .foregroundStyle(Color.primary)

            Text(plot)
                .font(.body)
                .foregroundStyle(Color.secondary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 20)
    }
}
