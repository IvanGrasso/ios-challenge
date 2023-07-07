//
//  ImageCache.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/7/23.
//

import Foundation
import UIKit

protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable { }

enum ImageCacheError: Error {
    case invalidURL
}

final class ImageCache {
    
    private struct CachedImage {
        let url: URL
        let data: Data
    }
    
    private struct CachedRequest: Cancellable {
        func cancel() { }
    }
    
    private var cache: [CachedImage] = []
    
    func loadImage(withURL urlString: String, completion: @escaping (UIImage?) -> Void) throws -> Cancellable {
        guard let url = URL(string: urlString) else { throw ImageCacheError.invalidURL }
        
        if let image = cachedImage(for: url) {
            completion(image)
            return CachedRequest()
        }
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            var image: UIImage? = UIImage(named: "image-placeholder")
            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            if let data = data {
                image = UIImage(data: data)
                self?.cacheImage(data, for: url)
            }
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    private func cacheImage(_ data: Data, for url: URL) {
        let cachedImage = CachedImage(url: url, data: data)
        cache.append(cachedImage)
    }
    
    private func cachedImage(for url: URL) -> UIImage? {
        guard let data = cache.first(where: { $0.url == url })?.data else {
            return nil
        }
        return UIImage(data: data)
    }
}
