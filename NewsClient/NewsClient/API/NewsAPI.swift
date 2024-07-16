//
//  NewsAPI.swift
//  NewsClient
//
//  Created by K on 12.07.2024.
//

import Foundation

class NewsAPI {
    
    func fetchData(completion: (NewsAPIResponse) -> Void, error: () -> Void) {
        completion(NewsAPIResponse.mockResponse)
    }
}

