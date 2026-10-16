//
//  MasonryLayout.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct MasonryLayout: Layout {

    var columns: Int = 2
    var spacing: CGFloat = 12

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        guard !subviews.isEmpty else {
            return .zero
        }

        let width = proposal.width ?? 0

        guard width > 0 else {
            return .zero
        }

        let columnWidth =
            (width - CGFloat(columns - 1) * spacing)
            / CGFloat(columns)

        var columnHeights = Array(
            repeating: CGFloat.zero,
            count: columns
        )

        for subview in subviews {

            let columnIndex = shortestColumn(
                heights: columnHeights
            )

            let size = subview.sizeThatFits(
                ProposedViewSize(
                    width: columnWidth,
                    height: nil
                )
            )

            columnHeights[columnIndex] += size.height + spacing
        }

        let height = max(0,(columnHeights.max() ?? 0) - spacing)

        return CGSize(width: width, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {

        guard !subviews.isEmpty else {
            return
        }

        let columnWidth =
            (bounds.width - CGFloat(columns - 1) * spacing)
            / CGFloat(columns)

        var columnHeights = Array(
            repeating: bounds.minY,
            count: columns
        )

        for subview in subviews {

            let columnIndex = shortestColumn(
                heights: columnHeights
            )

            let x =
                bounds.minX
                + CGFloat(columnIndex)
                * (columnWidth + spacing)

            let y = columnHeights[columnIndex]

            let size = subview.sizeThatFits(
                ProposedViewSize(
                    width: columnWidth,
                    height: nil
                )
            )

            subview.place(
                at: CGPoint(
                    x: x,
                    y: y
                ),
                anchor: .topLeading,
                proposal: ProposedViewSize(
                    width: columnWidth,
                    height: size.height
                )
            )

            columnHeights[columnIndex] +=
                size.height + spacing
        }
    }

    private func shortestColumn(heights: [CGFloat]) -> Int {

        heights.enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }
}
