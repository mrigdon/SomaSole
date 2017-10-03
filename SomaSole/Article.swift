//
//  Article.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class Article: Object {

    // MARK: - Object properties
    
    @objc dynamic var author = ""
    @objc dynamic var headline = ""
    @objc dynamic var body = ""
    @objc dynamic var date = Date()
    @objc dynamic var textImageURL = ""
    @objc dynamic var plainImageURL = ""
    
    // MARK: - Ignored properties
    
    @objc dynamic var textImage = UIImage()
    @objc dynamic var plainImage = UIImage()
    
    var textImageKey: String {
        return "text-\(headline)"
    }
    
    var plainImageKey: String {
        return "plain-\(headline)"
    }
    
    // MARK: - Initializers
    
    convenience init(data: [String : String]) {
        self.init()
        
        author = data["author"]!
        headline = data["headline"]!
        body = data["body"]!
        textImageURL = data["text_image_url"]!
        plainImageURL = data["plain_image_url"]!
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.somasoleDateFormat
        date = formatter.date(from: data["created_at_pretty"]!)!
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["textImage", "plainImage", "textImageKey", "plainImageKey"]
    }
    
    // MARK: - Methods
    
    func loadTextImage(_ completion: @escaping () -> Void) {
        // first check in cache, if not there, retrieve from s3
        ImageCache.default.retrieveImage(forKey: textImageKey, options: nil) { (image, type) in
            if let image = image {
                self.textImage = image
                completion()
            } else {
                ImageDownloader.default.downloadImage(with: URL(string: self.textImageURL)!, retrieveImageTask: nil, options: nil, progressBlock: nil) { (image, error, url, data) in
                    if let image = image {
                        self.textImage = image
                        ImageCache.default.store(image, forKey: self.textImageKey)
                        completion()
                    }
                }
            }
        }
    }
    
    func loadPlainImage(_ completion: @escaping () -> Void) {
        // first check in cache, if not there, retrieve from s3
        ImageCache.default.retrieveImage(forKey: plainImageKey, options: nil) { (image, type) in
            if let image = image {
                self.plainImage = image
                completion()
            } else {
                ImageDownloader.default.downloadImage(with: URL(string: self.plainImageURL)!, retrieveImageTask: nil, options: nil, progressBlock: nil) { (image, error, url, data) in
                    if let image = image {
                        self.plainImage = image
                        ImageCache.default.store(image, forKey: self.plainImageKey)
                        completion()
                    }
                }
            }
        }
    }
    
}
