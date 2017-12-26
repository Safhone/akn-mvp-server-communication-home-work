//
//  ImageSlideTableViewCell.swift
//  
//
//  Created by Safhone Oung on 12/25/17.
//

import UIKit

class ImageSlideTableViewCell: UITableViewCell{
    
    var homeViewController = ArticleTableViewController()
    var articles = [Article]()
    
    @IBOutlet weak var imageSlideCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageSlideCollectionView.delegate = self
        imageSlideCollectionView.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: imageSlideCollectionView.frame.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        imageSlideCollectionView.setCollectionViewLayout(layout, animated: true)
        imageSlideCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ImageSlideTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCollectionCell", for: indexPath) as! NewsCollectionViewCell
        cell.configureCell(article: articles[indexPath.item], page: indexPath.item)
        return cell
    }
    
}

extension ImageSlideTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.imageSlideCollectionView {
            let page = imageSlideCollectionView.frame.width
            _ = Int((scrollView.contentOffset.x + page / 2) / page)
        }
    }
}
