//
//  Video.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import Foundation
import RealmSwift
import Kingfisher
import Alamofire

class Video: Object {
    
    static var sharedFavorites = [Video]()
    
    // MARK: - Object properties
    
    dynamic var youtubeID = ""
    dynamic var deskription = ""
    dynamic var duration = 0
    dynamic var title = ""
    dynamic var date = NSDate()
    
    // MARK: - Ignored properties
    
    dynamic var image: UIImage?
    dynamic var favorite = false
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        self.youtubeID = data["youtube_id"] as! String
        self.title = data["title"] as! String
        self.duration = data["duration"] as! Int
        self.deskription = data["description"] as! String
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        date = formatter.dateFromString(data["created_at_pretty"] as! String)!
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["image", "favorite"]
    }
    
    // MARK: - Methods
    
    func loadImage(completion: () -> Void) {
        let url = "http://img.youtube.com/vi/\(youtubeID)/mqdefault.jpg"
        
        // first check in cache, if not there get from youtube
        ImageCache.defaultCache.retrieveImageForKey(url, options: nil) { image, type in
            if let image = image {
                self.image = image
                completion()
            } else {
                Alamofire.request(.GET, url).responseImage { response in
                    if let image = response.result.value {
                        self.image = image
                        completion()
                        ImageCache.defaultCache.storeImage(image, forKey: url)
                    }
                }
            }
        }
    }
    
}
