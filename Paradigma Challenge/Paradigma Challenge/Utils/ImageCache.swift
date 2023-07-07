//
//  ImageCache.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/7/23.
//

import Foundation
import UIKit

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let imageCache = NSCache<NSURL, UIImage>()
    
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = NSURL(string: urlString) else {
            DispatchQueue.main.async {
                let placeholder = UIImage(named: "image-placeholder")
                completion(placeholder)
            }
            return
        }
        
        if let cachedImage = cachedImage(for: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }

        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            guard let responseData = data, let image = UIImage(data: responseData),
                    error == nil else {
                DispatchQueue.main.async {
                    let placeholder = UIImage(named: "image-placeholder")
                    completion(placeholder)
                }
                return
            }
            
            self.imageCache.setObject(image, forKey: url, cost: responseData.count)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    private func cachedImage(for url: NSURL) -> UIImage? {
        return imageCache.object(forKey: url)
    }
}
