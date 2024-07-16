//
//  NewsItem+CoreDataProperties.swift
//  NewsClient
//
//  Created by K on 16.07.2024.
//
//

import Foundation
import CoreData


extension NewsItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsItem> {
        return NSFetchRequest<NewsItem>(entityName: "NewsItem")
    }

    @NSManaged public var detail: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var urlToImage: URL?

}

extension NewsItem : Identifiable {

}

extension NewsItem {
    static func newItem(with response: NewsItemResponse) -> NewsItem {
        let item = NewsItem()
        item.title = response.title
        item.detail = response.description
        item.url = URL(string: response.url ?? "")
        item.urlToImage = URL(string: response.urlToImage ?? "")
        item.publishedAt = item.publishedAt
        return item
    }
}
