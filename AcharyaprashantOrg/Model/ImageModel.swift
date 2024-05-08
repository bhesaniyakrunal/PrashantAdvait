//
//  ImageModel.swift
//  AcharyaprashantOrg
//
//  Created by MacBook on 5/6/24.
//

import Foundation
import UIKit
struct MediaCoverage: Codable {
    let id: String
    let title: String
    let thumbnail: Thumbnail
    let coverageURL: String
    let publishedAt: String
    let publishedBy: String
}

struct Thumbnail: Codable {
    let domain: String
    let basePath: String
    let key: String
}


