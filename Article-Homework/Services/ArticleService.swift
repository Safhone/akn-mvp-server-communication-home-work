//
//  ArticleService.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/23/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import Foundation
import Alamofire

class ArticleService {
    
    var delegate: ArticleServiceProtocol?

    var url = URL(string: "http://api-ams.me/v1/api/articles")!
    let uploadImageUrl = URL(string: "http://api-ams.me/v1/api/uploadfile/single")!
    var headers = [
        "Content-Type": "Application/json",
        "Accept" : "application/json",
        "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="
    ]
    
    func fetchArticles(atPage: Int, withLimitation: Int) {
        let get_url = "\(url)?page=\(atPage)&limit=\(withLimitation)"
        
        Alamofire.request(get_url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let data = response.data {
                var articles = [Article]()
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    
                    if let jsonArticle = jsonResult["DATA"] as? [AnyObject] {
                        for article in jsonArticle {
                            articles.append(Article(JSON: article as! [String: Any])!)
                        }
                        self.delegate?.didResponseData(articles: articles)
                        print("Success")
                    }
                } catch (let error){
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteArticle(articleId: Int) {
        Alamofire.request("\(url)/\(articleId)", method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { response in            print(((response.result.error != nil)) ? response.result.error?.localizedDescription as Any! : "Article is deleted successfully.")
        }
    }
    
    func saveArticle(article: Article, image: Data, isSave: Bool) {
        Alamofire.upload(multipartFormData: { (multipart) in
            multipart.append(image, withName: "FILE", fileName: ".jpg", mimeType: "image/jpeg")
        }, to: uploadImageUrl, method: .post, headers: headers) { encoding in
            switch encoding {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON(completionHandler: { (response) in
                    if let data = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any] {
                        var article: Article = article
                        article.image = data["DATA"] as? String

                        let parameters: Parameters = (image != UIImageJPEGRepresentation(#imageLiteral(resourceName: "no image"), 1)) ? [
                                "TITLE" : article.title!,
                                "DESCRIPTION" : article.description!,
                                "IMAGE" : article.image!
                            ] : [
                                "TITLE" : article.title!,
                                "DESCRIPTION" : article.description!
                        ]
                        
                        if isSave {
                            Alamofire.request("\(self.url)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers).responseJSON { response in
                                if response.result.isSuccess {
                                    print("Saved Success")
                                }
                            }
                        } else {
                            Alamofire.request("\(self.url)/\(article.id!)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers).responseJSON { response in
                                if response.result.isSuccess {
                                    print("Updated Success")
                                }
                            }
                        }
                    }
                })
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
