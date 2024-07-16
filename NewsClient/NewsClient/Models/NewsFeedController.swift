//
//  NewsFeedController.swift
//  NewsClient
//
//  Created by K on 12.07.2024.
//

import Foundation
import UIKit

protocol NewsFeedControllerDelegate: AnyObject {
    func refreshUI()
}

class NewsFeedController: NSObject {
    // MARK: - Properties
    private let cellIdentifier = "newsCell"
    
    private let api = NewsAPI()
    private var dataSource = [NewsItem]()
    weak var tableView: UITableView?
    weak var delegate: NewsFeedControllerDelegate?
    
    // MARK: - Public methods
    
    func setup() {
        tableView?.register(.init(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func loadData() {
        api.fetchData { [weak self] response in
            self?.dataSource = response.articles
            self?.delegate?.refreshUI()
        } error: {
            print("API error")
        }
    }
}

extension NewsFeedController: UITableViewDelegate {
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
    }
    
    func didTapShare(_ cell: UITableViewCell) {
    }
}
