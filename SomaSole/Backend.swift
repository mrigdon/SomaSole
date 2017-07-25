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
                featured.articles = (json["articles"] as! [[String : String]]).map { Article(data: $0) }
                featured.workout = Workout(data: json["workout"] as! [String : AnyObject])
                
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
