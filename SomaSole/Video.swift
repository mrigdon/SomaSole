//
//  Video.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/4/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Kingfisher

class Video: NSObject {
    
    static var sharedFavorites = [Video]()

    var id = ""
    var title = ""
    var time = 0
    var videoDescription = ""
    var favorite = false
    var free = false
    var image: UIImage?
    var date = NSDate()
    
    init(id: String, data: [String:AnyObject]) {
        super.init()
        self.id = id
        self.title = data["title"] as! String
        self.time = data["time"] as! Int
        self.videoDescription = data["description"] as! String
        
        // parse date
        if let dateString = data["date"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .LongStyle
            formatter.timeStyle = .LongStyle
            if let date = formatter.dateFromString(dateString) {
                self.date = date
            }
        }
    }
    
    func loadImage(completion: () -> Void) {
        let url = "http://img.youtube.com/vi/\(id)/mqdefault.jpg"
        
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
