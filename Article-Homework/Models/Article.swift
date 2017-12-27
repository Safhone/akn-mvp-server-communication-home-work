//
//  Article.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/23/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import Foundation
import ObjectMapper

struct Article {
    var id: Int?
    var title: String?
    var description: String?
    var created_date: String?
    var image: String?
    var pagination: Pagination?
}

extension Article: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["ID"]
        title <- map["TITLE"]
        description <- map["DESCRIPTION"]
        created_date <- map["CREATED_DATE"]
        image <-  map["IMAGE"]
        pagination <- map["PAGINATION"]
    }
    
}
