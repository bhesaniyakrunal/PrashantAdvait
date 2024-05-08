//
//  NetworkService.swift
//  AcharyaprashantOrg
//
//  Created by MacBook on 5/6/24.
//

import Foundation
import UIKit

class APIManager {
    func fetchMediaCoverages(completion: @escaping (Result<[MediaCoverage], Error>) -> Void) {
        // Make API request and parse JSON response
        // Here you would use URLSession or any networking library to make the actual API call
        // For the sake of this example, we'll use a hardcoded JSON response
        guard let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            do {
                let mediaCoverages = try JSONDecoder().decode([MediaCoverage].self, from: data)
                completion(.success(mediaCoverages))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Fetch image from URL
        guard let imageURL = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid image URL", code: 0, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "Invalid image data", code: 0, userInfo: nil)))
                return
            }
            completion(.success(image))
        }.resume()
    }
}

