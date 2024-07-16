//
//  NewsFeedCell.swift
//  NewsClient
//
//  Created by K on 12.07.2024.
//

import Foundation
import UIKit
import SDWebImage

class NewsFeedCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var favButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!

    
    weak var delegate: NewsFeedCellDelegate?
    
    func setup(with newsItem: NewsItemViewModel, delegate: NewsFeedCellDelegate?) {
        self.delegate = delegate
        titleLabel.text = newsItem.title
        descriptionLabel.text = newsItem.description
        let publishedAt = newsItem.publishedAt ?? Date.now
        dateLabel.text = publishedAt.timeAgoDisplay()
        if let url = newsItem.urlToImage {
            mainImageView.contentMode = .scaleAspectFill
            mainImageView.sd_setImage(with: url)
        } else {
            mainImageView.contentMode = .scaleAspectFit
            mainImageView.image = UIImage(systemName: "newspaper.fill")
        }
        favButton.setImage(UIImage(systemName: newsItem.isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
    
   // MARK: Actions
    
    @IBAction func favAction(_ sender: UIButton) {
        delegate?.didTapFavorite(self)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
    }
}

protocol NewsFeedCellDelegate: AnyObject {
    func didTapFavorite(_ cell: UITableViewCell)
    func didTapShare(_ cell: UITableViewCell)
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
