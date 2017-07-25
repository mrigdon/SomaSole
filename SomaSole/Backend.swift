//
//  Backend.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/24/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import UIKit
import Alamofire

struct Featured {
    var articles = [Article]()
    var videos = [Video]()
    var workout: Workout!
    
    init() {
        
    }
    
    init(articles: [Article], videos: [Video], workout: Workout) {
        self.articles = articles
        self.videos = videos
        self.workout = workout
    }
}

class Backend: NSObject {
    
    // MARK: - Singleton
    
    static let shared = Backend()
    
    // MARK: - Private properties
    
    private let baseURL = "http://localhost:3000"
    
    // MARK: - Public methods
    
    func getFeatured(completion: (Featured?) -> Void) {
        Alamofire.request(.GET, url("/featured.json")).responseJSON { response in
            if let json = response.result.value {
                var featured = Featured()
                
                let articles = json["articles"] as? [[String : String]] ?? [[String : String]]()
                featured.articles = articles.map { Article(data: $0) }
                
                completion(featured)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func url(string: String) -> String {
        return "\(baseURL)\(string)"
    }

}
