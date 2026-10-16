//
//  ViewModelBase.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Combine

enum LoadingState {
    case none
    case loading
    case success
    case failure
}

class ViewModelBase: ObservableObject {
    @Published var loadingState: LoadingState = .none
}
