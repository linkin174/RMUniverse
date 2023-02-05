//
//  CachedAsyncImage.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 05.02.2023.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    init(url: URL,
         scale: CGFloat = 1.0,
         transaction: Transaction,
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    } 

    var body: some View {
        if let cached = ImageCache[url] {
            content(cached)
        } else {
            AsyncImage(url: url,
                       scale: scale,
                       transaction: transaction) { phase in
                switch phase {
                case .empty:
                    placeholder()
                case .success:
                    cacheAndRender(phase: phase)
                default: EmptyView()
                }
            }
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase.image!)
    }
}

 struct CachedAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedAsyncImage(url: URL(string: "https://picsum.photos/id/823/200/300")!,
                         transaction: .init(animation: .easeOut)) { image in
            image
        } placeholder: {
            ProgressView()
        }
    }
 }

private enum ImageCache {
    private static var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        } set {
            ImageCache.cache[url] = newValue
        }
    }
}
