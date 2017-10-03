//
//  Video.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class Video: Object {

    static var sharedFavorites = [Video]()
    
    // MARK: - Object properties
    
    @objc dynamic var youtubeID = ""
    @objc dynamic var deskription = ""
    @objc dynamic var duration = 0
    @objc dynamic var title = ""
    @objc dynamic var date = Date()
    @objc dynamic var featured = false
    
    // MARK: - Ignored properties
    
    @objc dynamic var image: UIImage?
    @objc dynamic var favorite = false
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        self.youtubeID = data["youtube_id"] as! String
        self.title = data["title"] as! String
        self.duration = data["duration"] as! Int
        self.deskription = data["description"] as! String
        self.featured = data["featured"] as! Bool
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.somasoleDateFormat
        date = formatter.date(from: data["created_at_pretty"] as! String)!
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["image", "favorite"]
    }
    
    // MARK: - Methods
    
    func loadImage(_ completion: @escaping () -> Void) {
        let url = "http://img.youtube.com/vi/\(youtubeID)/mqdefault.jpg"
        ImageCache.default.retrieveImage(forKey: title, options: nil) { (image, type) in
            if let image = image {
                self.image = image
                completion()
            } else {
                ImageDownloader.default.downloadImage(with: URL(string: url)!, retrieveImageTask: nil, options: nil, progressBlock: nil) { (image, error, url, data) in
                    if let image = image {
                        self.image = image
                        ImageCache.default.store(image, forKey: self.title)
                        completion()
                    }
                }
            }
        }
    }
    
}
