//
//  NewsAPIResponse.swift
//  NewsClient
//
//  Created by K on 12.07.2024.
//

import Foundation

struct NewsAPIResponse: Codable {
    let articles: [NewsItemResponse]
}

extension NewsAPIResponse {
    static var mockResponse: NewsAPIResponse {
        return NewsAPIResponse(articles: [
            .init(
                title: "A",
                description: "Title A",
                url: "https://financialpost.com/investing/apple-nvidia-big-tech-stocks-steve-eisman",
                urlToImage: "https://smartcdn.gprod.postmedia.digital/financialpost/wp-content/uploads/2024/07/0713-bc-stocks-.jpg",
                publishedAt: Date.now
            ),
            .init(
                title: "B",
                description: "Title B",
                url: "https://financialpost.com/investing/apple-nvidia-big-tech-stocks-steve-eisman",
                urlToImage: "https://smartcdn.gprod.postmedia.digital/financialpost/wp-content/uploads/2024/07/0713-bc-stocks-.jpg",
                publishedAt: Date.now
            ),
            .init(
                title: "C",
                description: "Title C",
                url: "https://financialpost.com/investing/apple-nvidia-big-tech-stocks-steve-eisman",
                urlToImage: "https://smartcdn.gprod.postmedia.digital/financialpost/wp-content/uploads/2024/07/0713-bc-stocks-.jpg",
                publishedAt: Date.now
            ),
        ])
    }
}
