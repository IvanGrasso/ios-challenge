//
//  ImageService.swift
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

enum imageServiceError: Error {
    case invalidURL
}

final class ImageService {
    
    private struct CachedImage {
        let url: URL
        let data: Data
    }
    
    private struct CachedRequest: Cancellable {
        func cancel() { }
    }
    
    private let cache = NSCache<NSURL, NSData>()
    
    // URLSession cache is disabled for testing purposes.
    private let urlSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    private let queue = DispatchQueue(label: "image-cache-queue", attributes: .concurrent)
    
    func image(forURL urlString: String, completion: @escaping (UIImage?) -> Void) throws -> Cancellable {
        guard let url = URL(string: urlString) else { throw imageServiceError.invalidURL }
        
        if let image = cachedImage(for: url) {
            completion(image)
            return CachedRequest()
        }
        
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self?.cacheImage(data, for: url)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    private func cacheImage(_ data: Data, for url: URL) {
        let cachedImage = CachedImage(url: url, data: data)
        queue.async(flags: .barrier) {
            self.cache.append(cachedImage)
        }
    }
    
    private func cachedImage(for url: URL) -> UIImage? {
        guard let data = queue.sync(execute: {
            cache.first(where: { $0.url == url })?.data
        }) else {
            return nil
        }
        return UIImage(data: data)
    }
}
