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
    @NSManaged public var isFavorite: NSNumber?
    @NSManaged public var detail: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var urlToImage: URL?

}

extension NewsItem : Identifiable {

}
