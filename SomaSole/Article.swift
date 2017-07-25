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
    
    let textImageDimensions: Int64 = 1 * 1400 * 900
    let plainImageDimensions: Int64 = 1 * 1400 * 1400

    var author = ""
    var date: NSDate!
    var textImage = UIImage()
    var plainImage = UIImage()
    var headline = ""
    var body = ""
    var textImageURL = ""
    var plainImageURL = ""
    
    init(date: String, data: [String:String]) {
        author = data["author"]!
        headline = data["headline"]!
        body = data["body"]!
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .FullStyle
        self.date = formatter.dateFromString(date)!
    }
    
    init(data: [String : String]) {
        author = data["author"]!
        headline = data["headline"]!
        body = data["body"]!
        textImageURL = data["text_image_url"]!
        plainImageURL = data["plain_image_url"]!
        date = NSDate()
    }
    
    func loadImages(completion: () -> Void) {
        let file = headline + ".jpg"
        
        // first load text
        let textImageRef = FirebaseManager.sharedStorage.child("articles/text").child(file)
        textImageRef.dataWithMaxSize(textImageDimensions, completion: { data, error in
            if error != nil {
                // TODO: handle error
                print(error)
            } else if let data = data {
                if let image = UIImage(data: data) {
                    self.textImage = image
                    completion()
                }
            }
        })
        
        // then load plain
        let plainImageRef = FirebaseManager.sharedStorage.child("articles/plain").child(file)
        plainImageRef.dataWithMaxSize(plainImageDimensions, completion: { data, error in
            if error != nil {
                // TODO: handle error
                print(error)
            } else if let data = data {
                if let image = UIImage(data: data) {
                    self.plainImage = image
                }
            }
        })
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
        let file = headline + ".jpg"
        let key = "plain_\(file)"
        
        // first check in cache, if not there, get from firebase
        ImageCache.defaultCache.retrieveImageForKey(key, options: nil) { image, type in
            if let image = image {
                self.plainImage = image
                completion()
            } else {
                let imageRef = FirebaseManager.sharedStorage.child("articles/plain").child(file)
                imageRef.dataWithMaxSize(self.plainImageDimensions) { data, error in
                    if error != nil {
                        // TODO: handle error
                        print(error)
                    } else if let data = data {
                        if let image = UIImage(data: data) {
                            self.plainImage = image
                            completion()
                            ImageCache.defaultCache.storeImage(image, forKey: key)
                        }
                    }
                }
            }
        }
    }
    
}
