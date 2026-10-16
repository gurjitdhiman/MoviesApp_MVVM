//
//  Constants.swift
//  MoviesApp
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import Foundation

struct Constants {
    static let API_KEY = "YOUR_OMDB_API"
    static let ENVIRONMENT: Environment = .live
    static let ApiBaseURLString: String = "https://www.omdbapi.com/"
}

enum Environment {
    case live
    case local
}

