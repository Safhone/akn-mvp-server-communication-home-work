//
//  ArticleServiceProtocol.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/23/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import Foundation

protocol ArticleServiceProtocol: class {
    
    func didResponseData(articles: [Article])
    
}
