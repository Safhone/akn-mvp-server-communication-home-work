//
//  ArticleTableViewCell.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/22/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var logoAritcleFromImageView: UIImageView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleArticleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        saveButton.layer.cornerRadius = 5
        logoAritcleFromImageView.layer.masksToBounds = false
        logoAritcleFromImageView.layer.cornerRadius = logoAritcleFromImageView.frame.size.height / 2
        logoAritcleFromImageView.clipsToBounds = true
    }
    
    func configureCell(article: Article) {
        titleArticleLabel.text = article.title
        articleImageView.kf.setImage(with: URL(string: article.image ?? "Not Available"), placeholder: #imageLiteral(resourceName: "no image"))
        let date = Date(timeIntervalSince1970: Double(article.created_date!)!)
        dateLabel.text = date.string(with: "YYYY-MMM-dd")
    }
    
}

extension Date {
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
