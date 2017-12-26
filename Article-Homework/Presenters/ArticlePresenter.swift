//
//  ArticlePresenter.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/25/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import Foundation

class ArticlePresenter {
   
    var delegate: ArticlePresenterProtocol?
    var articleService: ArticleService?
    
    init() {
        articleService = ArticleService()
        articleService?.delegate = self
    }
    
    func getArticle(atPage: Int, withLimitation: Int) {
        articleService?.fetchArticles(atPage: atPage, withLimitation: withLimitation)
    }
    
    func deleteArticle(articleId: Int) {
        articleService?.deleteArticle(articleId: articleId)
    }
    
    func saveArticle(article: Article, image: Data, isSave: Bool) {
        articleService?.saveArticle(article: article, image: image, isSave: isSave)
    }
    
}

extension ArticlePresenter: ArticleServiceProtocol {
    
    func didResponseData(articles: [Article]) {
        self.delegate?.didResponseData(articles: articles)
    }
    
}
