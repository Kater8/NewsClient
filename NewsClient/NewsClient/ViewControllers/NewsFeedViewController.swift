//
//  NewsFeedViewController.swift
//  NewsClient
//
//  Created by K on 12.07.2024.
//

import Foundation
import UIKit

class NewsFeedViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    private let controller = NewsFeedController()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        controller.loadData()
    }
    
    // MARK: Private methods
    
    private func setup() {
        self.controller.tableView = self.tableView
        self.controller.delegate = self
        self.controller.setup()
    }
}

// MARK: - NewsFeedControllerDelegate
extension NewsFeedViewController: NewsFeedControllerDelegate {
    func refreshUI() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
