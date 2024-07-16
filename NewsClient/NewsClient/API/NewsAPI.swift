//
//  NewsAPI.swift
//  NewsClient
//
//  Created by K on 12.07.2024.
//

import Foundation

class NewsAPI {
    
    func fetchData(completion: @escaping (NewsAPIResponse) -> Void, error: @escaping () -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=77f770826ae94225928d2ada23c10783") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, URLResponse, requestError) in
            if requestError != nil {
                error()
                return
            }
            
            guard let data = data else {
                error()
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let response = try decoder.decode(NewsAPIResponse.self, from: data)
                completion(response)
            } catch let error {
                print("Error decoding:\n\(error)")
            }
        }.resume()

    }
}
