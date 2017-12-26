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
        dateLabel.text = article.created_date!.formatDate(getTime: false)
    }
    
}

extension String {
    func subString(startIndex: Int, endIndex: Int) -> String {
        let end = (endIndex - self.count) + 1
        let indexStartOfText = self.index(self.startIndex, offsetBy: startIndex)
        let indexEndOfText = self.index(self.endIndex, offsetBy: end)
        let substring = self[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
    
    func formatDate(getTime: Bool) -> String {
        if getTime {
            return "\(self.subString(startIndex: 6, endIndex: 7))-\(self.subString(startIndex: 4, endIndex: 5))-\(self.subString(startIndex: 0, endIndex: 3)) / \(self.subString(startIndex: 8, endIndex: 9)):\(self.subString(startIndex: 10, endIndex: 11))"
        } else {
            return "\(self.subString(startIndex: 6, endIndex: 7))-\(self.subString(startIndex: 4, endIndex: 5))-\(self.subString(startIndex: 0, endIndex: 3))"
        }
    }
}
