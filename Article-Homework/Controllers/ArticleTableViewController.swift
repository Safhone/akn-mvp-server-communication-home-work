//
//  ArticleTableViewController.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/22/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit

class ArticleTableViewController: UIViewController {
  
    @IBOutlet weak var newsTableView: UITableView!
    var articles = [Article]()
    var articlePresenter: ArticlePresenter?
    
    let paginationIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var increasePage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.preservesSuperviewLayoutMargins = false
        newsTableView.separatorInset = UIEdgeInsets.zero
        newsTableView.layoutMargins = UIEdgeInsets.zero
        newsTableView.addSubview(refreshControl)
        
        articlePresenter = ArticlePresenter()
        articlePresenter?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        articles.removeAll()
        increasePage = 1
        articlePresenter?.getArticle(atPage: 1, withLimitation: 15)
        newsTableView.reloadData()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        articles.removeAll()
        articlePresenter?.getArticle(atPage: 1, withLimitation: 15)
        newsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        
        if distanceFromBottom < height {
            increasePage = increasePage + 1
            self.newsTableView.tableFooterView = paginationIndicatorView
            self.newsTableView.tableFooterView?.isHidden = false
            self.newsTableView.tableFooterView?.center = paginationIndicatorView.center
            self.paginationIndicatorView.startAnimating()
            articlePresenter?.getArticle(atPage: increasePage, withLimitation: 15)
            newsTableView.reloadData()
        }
    }
    
}

extension ArticleTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageSlideCell") as! ImageSlideTableViewCell
            cell.articles = articles
            cell.imageSlideCollectionView.reloadData()
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("ArticleTableViewCell", owner: self, options: nil)?.first as! ArticleTableViewCell
            cell.configureCell(article: articles[indexPath.item - 1])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsStoryboard = self.storyboard?.instantiateViewController(withIdentifier: "newsStoryboardID") as! NewsViewController
        newsStoryboard.newsTitle = articles[indexPath.row - 1].title
        newsStoryboard.newsDate = articles[indexPath.row - 1].created_date
        newsStoryboard.newsImage = articles[indexPath.row - 1].image
        newsStoryboard.newsDescription = articles[indexPath.row - 1].description
        self.navigationController?.pushViewController(newsStoryboard, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.row != 0 {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
                let alert = UIAlertController(title: "Are you sure to delete?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                    DispatchQueue.main.async {
                        self.articlePresenter?.deleteArticle(articleId: self.articles[indexPath.row - 1].id!)
                        self.articles.remove(at: indexPath.row - 1)
                        self.newsTableView.reloadData()
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
            
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
                
            }
            
            return [delete, edit]
            
        }
        
        return []
    }
    
}

extension ArticleTableViewController: ArticlePresenterProtocol {
    func didResponseData(articles: [Article]) {
        self.articles += articles
        newsTableView.reloadData()
    }
}
