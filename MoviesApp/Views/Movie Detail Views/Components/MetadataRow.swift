//
//  MetadataRow.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MetadataRow: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.primary.opacity(0.85))
                .frame(width: 24)

            Text(title)
                .foregroundStyle(Color.secondary)
                .frame(width: 95, alignment: .leading)

            Text(value.isEmpty ? "N/A" : value)
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(.subheadline)
    }
}
