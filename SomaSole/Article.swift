//
//  Article.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/27/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Kingfisher

class Article: NSObject {

    var author = ""
    var date = NSDate()
    var textImage = UIImage()
    var plainImage = UIImage()
    var headline = ""
    var body = ""
    var textImageURL = ""
    var plainImageURL = ""
    
    init(data: [String : String]) {
        author = data["author"]!
        headline = data["headline"]!
        body = data["body"]!
        textImageURL = data["text_image_url"]!
        plainImageURL = data["plain_image_url"]!
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        date = formatter.dateFromString(data["created_at_pretty"]!)!
    }
    
    func loadTextImage(completion: () -> Void) {
        // first check in cache, if not there, retrieve from s3
        ImageCache.defaultCache.retrieveImageForKey(textImageURL, options: nil) { image, type in
            if let image = image {
                self.textImage = image
                completion()
            } else {
                let url = NSURL(string: self.textImageURL)
                ImageDownloader.defaultDownloader.downloadImageWithURL(url!, progressBlock: nil, completionHandler: { (image, error, url, data) in
                    self.textImage = image!
                    completion()
                    ImageCache.defaultCache.storeImage(image!, forKey: self.textImageURL)
                })
            }
        }
    }
    
    func loadPlainImage(completion: () -> Void) {
        // first check in cache, if not there, retrieve from s3
        ImageCache.defaultCache.retrieveImageForKey(plainImageURL, options: nil) { image, type in
            if let image = image {
                self.plainImage = image
                completion()
            } else {
                let url = NSURL(string: self.plainImageURL)
                ImageDownloader.defaultDownloader.downloadImageWithURL(url!, progressBlock: nil, completionHandler: { (image, error, url, data) in
                    self.plainImage = image!
                    completion()
                    ImageCache.defaultCache.storeImage(image!, forKey: self.plainImageURL)
                })
            }
        }
    }
    
}
