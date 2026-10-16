//
//  URLImage.swift
//  URLImageDemo
//
//  Created by Gurjit's Macbook on 30/08/26.
//  Copyright © 2026 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct URLImage: View {

    let url: String?
    let placeholder: String
    let cachePolicy: ImageCachePolicy
    let maxAge: TimeInterval?

    @StateObject private var imageLoader: ImageLoader

    init(
        url: String?,
        placeholder: String = "placeholder",
        cachePolicy: ImageCachePolicy = .useCache,
        maxAge: TimeInterval? = nil
    ) {
        self.url = url
        self.placeholder = placeholder
        self.cachePolicy = cachePolicy
        self.maxAge = maxAge
        _imageLoader = StateObject(
            wrappedValue: ImageLoader(
                url: cachePolicy == .useCache ? url : nil,
                maxAge: maxAge
            )
        )
    }

    var body: some View {
        content
            .task(id: url) {
                if let url, !url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    await imageLoader.load(url: url, policy: cachePolicy, maxAge: maxAge)
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if let image = imageLoader.image {
            Image(uiImage: image).resizable()
        } else {
            Image(placeholder).resizable()
        }
    }
}


struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(url: "https://fyrafix.files.wordpress.com/2011/08/url-8.jpg")
    }
}
