//
//  ImageViewModel.swift
//  AcharyaprashantOrg
//
//  Created by MacBook on 5/6/24.
//

import UIKit
import Foundation


class MediaCoverageViewModel {
    private let apiManager: APIManager
     var mediaCoverages: [MediaCoverage] = []
    private var imageCache: NSCache<NSString, UIImage> = NSCache()
    private let diskCacheDirectory: URL
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
        // Initialize disk cache directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.diskCacheDirectory = documentsDirectory.appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: self.diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func fetchMediaCoverages(completion: @escaping ([MediaCoverage]) -> Void) {
        apiManager.fetchMediaCoverages { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let mediaCoverages):
                self.mediaCoverages = mediaCoverages
                completion(mediaCoverages)
            case .failure(let error):
                print("Error fetching media coverages: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func loadImage(for indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        let mediaCoverage = mediaCoverages[indexPath.item]
        let imageURL = "\(mediaCoverage.thumbnail.domain)/\(mediaCoverage.thumbnail.basePath)/0/\(mediaCoverage.thumbnail.key)"
        
        // Check memory cache
        if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
            completion(cachedImage)
            return
        }
        
        // Check disk cache
        let cachedImagePath = diskCacheDirectory.appendingPathComponent(mediaCoverage.id)
        if let imageData = try? Data(contentsOf: cachedImagePath), let cachedImage = UIImage(data: imageData) {
            // Update memory cache
            imageCache.setObject(cachedImage, forKey: imageURL as NSString)
            completion(cachedImage)
            return
        }
        
        // If not found in cache, fetch from URL
        apiManager.fetchImage(from: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                // Save to disk cache
                if let data = image.pngData() {
                    try? data.write(to: cachedImagePath)
                }
                // Update memory cache
                self.imageCache.setObject(image, forKey: imageURL as NSString)
                completion(image)
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}


