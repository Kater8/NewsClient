//
//  NewsFeedController.swift
//  NewsClient
//
//  Created by K on 12.07.2024.
//

import Foundation
import UIKit
import CoreData

protocol NewsFeedControllerDelegate: AnyObject {
    func refreshUI()
}

class NewsFeedController: NSObject {
    // MARK: - Properties
    private let cellIdentifier = "newsCell"
    
    private let api = NewsAPI()
    private var dataSource = [NewsItemViewModel]()
    weak var tableView: UITableView?
    weak var delegate: NewsFeedControllerDelegate?
    
    // MARK: - Public methods
    
    func setup() {
        tableView?.register(.init(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func deleteAllData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NewsItem.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try! managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            try! managedContext.save()

        } catch let error as NSError {
        }
    }

    func loadData() {
        api.fetchData { response in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.storeResponse(response.articles)
                let storedItems = self.fetchStoredData()
                self.updateDataSource(with: storedItems)
            }
        } error: { [weak self] in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let storedItems = self.fetchStoredData()
                self.updateDataSource(with: storedItems)
                print("API error")
            }
        }
    }
    
    // MARK: - Private methods
    
    private func showDetails(at indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        if let detailsURL = item.url {
            UIApplication.shared.open(detailsURL)
        }
    }
    
    private func storeResponse(_ response: [NewsItemResponse]) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let storedItems = fetchStoredData()
        response.forEach { self.store(
            item: $0,
            in: managedContext,
            storedItems: storedItems)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func store(item: NewsItemResponse, in managedContext: NSManagedObjectContext, storedItems: [NewsItem]) {
        let entity =
        NSEntityDescription.entity(forEntityName: "NewsItem",
                                   in: managedContext)!
        
        let coreDataObject: NSManagedObject
        if let existingObject = storedItems.first(where: { storedItem in
            return storedItem.url != nil && storedItem.url == URL(string: item.url ?? "")
        }) {
            coreDataObject = existingObject
        } else {
            coreDataObject = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
        }
        coreDataObject.setValue(item.title, forKeyPath: "title")
        coreDataObject.setValue(item.description, forKeyPath: "detail")
        coreDataObject.setValue(URL(string: item.url ?? ""), forKeyPath: "url")
        coreDataObject.setValue(URL(string: item.urlToImage ?? ""), forKeyPath: "urlToImage")
        coreDataObject.setValue(item.publishedAt, forKeyPath: "publishedAt")
    }
    
    private func fetchStoredData() -> [NewsItem] {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let request = NewsItem.fetchRequest()
        let sort = NSSortDescriptor(key: "publishedAt", ascending: true)
        request.sortDescriptors = [sort]

        do {
            return try managedContext.fetch(request)
        } catch {
            return []
        }
    }
    
    private func updateDataSource(with items: [NewsItem]) {
        self.dataSource = items.map({ item in
            NewsItemViewModel.newInstance(with: item)
        })
        self.delegate?.refreshUI()
    }
    
    private func item(in cell: UITableViewCell) -> NewsItemViewModel? {
        if let indexPath = tableView?.indexPath(for: cell) {
            return dataSource[indexPath.row]
        } else {
             return nil
        }
    }
    
    private func changeFavoriteFor(item: NewsItemViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext

            let request = NewsItem.fetchRequest()
            let sort = NSSortDescriptor(key: "publishedAt", ascending: true)
            if let url = item.url,
            let nsUrl = NSURL(string: url.absoluteString) {
                request.predicate = NSPredicate(format: "url == %@", nsUrl as CVarArg)
            } else {
                request.predicate = NSPredicate(format: "title == %@", item.title)
            }
            do {
                if let result = try managedContext.fetch(request).first {
                    if result.isFavorite?.boolValue == true {
                        result.isFavorite = false
                    } else {
                        result.isFavorite = true
                    }
                }
                try managedContext.save()
                let updated = self.fetchStoredData()
                self.updateDataSource(with: updated)
            } catch {
                return
            }

        }
    }
}

extension NewsFeedController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetails(at: indexPath)
    }
}

extension NewsFeedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        (cell as? NewsFeedCell)?.setup(with: dataSource[indexPath.row], delegate: self)
        return cell
    }
}

extension NewsFeedController: NewsFeedCellDelegate {
    func didTapFavorite(_ cell: UITableViewCell) {
        if let item = item(in: cell) {
            changeFavoriteFor(item: item)
        }
    }
    
    func didTapShare(_ cell: UITableViewCell) {
    }
}
