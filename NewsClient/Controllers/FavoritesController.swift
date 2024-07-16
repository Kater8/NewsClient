//
//  FavoritesController.swift
//  NewsClient
//
//  Created by K on 17.07.2024.
//

import Foundation
import UIKit
import CoreData

protocol FavoritesControllerDelegate: AnyObject {
    func refreshUI()
    func share(item: NewsItemViewModel)
}

class FavoritesController: NSObject {
    // MARK: - Properties
    private let cellIdentifier = "newsCell"
    
    private var dataSource = [NewsItemViewModel]()
    weak var tableView: UITableView?
    weak var delegate: FavoritesControllerDelegate?
    
    // MARK: - Public methods
    
    func setup() {
        tableView?.register(.init(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func loadData() {
        let storedItems = self.fetchStoredData()
        self.updateDataSource(with: storedItems)
    }
    
    // MARK: - Private methods
    
    private func showDetails(at indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        if let detailsURL = item.url {
            UIApplication.shared.open(detailsURL)
        }
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
        request.predicate = NSPredicate(format: "isFavorite == true")

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

extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetails(at: indexPath)
    }
}

extension FavoritesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        (cell as? NewsFeedCell)?.setup(with: dataSource[indexPath.row], delegate: self)
        return cell
    }
}

extension FavoritesController: NewsFeedCellDelegate {
    func didTapFavorite(_ cell: UITableViewCell) {
        if let item = item(in: cell) {
            changeFavoriteFor(item: item)
        }
    }
    
    func didTapShare(_ cell: UITableViewCell) {
        if let item = item(in: cell) {
            delegate?.share(item: item)
        }
    }
}
