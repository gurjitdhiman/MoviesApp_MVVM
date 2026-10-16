//
//  FailedView.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct FailedView: View {
    var message: String? = nil
    
    var body: some View {
        ContentUnavailableView {
            Label("No Data Found!", systemImage: "exclamationmark.octagon.fill")
        } description: {
            if let message {
                Text(message)
            }
        }
    }
}

#Preview {
    FailedView(message: "Something went wrong while loading movies. Please try again.")
}
