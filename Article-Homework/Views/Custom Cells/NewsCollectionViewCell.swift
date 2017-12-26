//
//  NewsCollectionViewCell.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/25/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var pageNewsLabel: UILabel!
    @IBOutlet weak var titleNewsLabel: UILabel!
    
    func configureCell(article: Article, page: Int) {
        newsImageView.kf.setImage(with: URL(string: article.image ?? "Not Available"), placeholder: #imageLiteral(resourceName: "no image"))
        titleNewsLabel.text = String(describing: "   \(article.title!)")
        pageNewsLabel.text = String(page + 1)
    }
    
}
