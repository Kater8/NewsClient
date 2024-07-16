//
//  NewsItemResponse.swift
//  NewsClient
//
//  Created by K on 12.07.2024.
//

import Foundation


struct NewsItemResponse: Codable {
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
}
