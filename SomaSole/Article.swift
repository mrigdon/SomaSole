//
//  Article.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import Foundation
import RealmSwift
import Kingfisher

class Article: Object {
    
    // MARK: - Object properties
    
    dynamic var author = ""
    dynamic var headline = ""
    dynamic var body = ""
    dynamic var date = NSDate()
    dynamic var textImageURL = ""
    dynamic var plainImageURL = ""
    
    // MARK: - Ignored properties
    
    dynamic var textImage = UIImage()
    dynamic var plainImage = UIImage()
    
    // MARK: - Initializers
    
    convenience init(data: [String : String]) {
        self.init()
        
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
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["textImage", "plainImage"]
    }
    
    // MARK: - Methods
    
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
