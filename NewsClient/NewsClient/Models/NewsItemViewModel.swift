//
//  NewsItemViewModel.swift
//  NewsClient
//
//  Created by K on 16.07.2024.
//

import Foundation

struct NewsItemViewModel: Codable {
    let isFavorite: Bool
    let title: String
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date?
}

extension NewsItemViewModel {
    static func newInstance(with responseModel: NewsItemResponse) -> NewsItemViewModel {
        return NewsItemViewModel(
            isFavorite: false,
            title: responseModel.title,
            description: responseModel.description,
            url: URL(string: responseModel.url ?? ""),
            urlToImage: URL(string: responseModel.urlToImage ?? ""),
            publishedAt: responseModel.publishedAt
        )
    }
    
    static func newInstance(with coreDataModel: NewsItem) -> NewsItemViewModel {
        return NewsItemViewModel(
            isFavorite:coreDataModel.isFavorite?.boolValue ?? false,
            title: coreDataModel.title ?? "",
            description: coreDataModel.detail,
            url: coreDataModel.url,
            urlToImage: coreDataModel.urlToImage,
            publishedAt: coreDataModel.publishedAt)
    }
}
