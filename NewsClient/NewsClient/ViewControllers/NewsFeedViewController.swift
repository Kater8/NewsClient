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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func share(item: NewsItemViewModel) {
        var activityItems: [Any] = [item.title]
        if let url = item.url {
            activityItems.append(url)
        }
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
