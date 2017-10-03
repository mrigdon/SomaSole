//
//  Workout.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class Workout: Object {

    static var sharedFavorites = [Workout]()
    
    // MARK: - Object properties
    
    @objc dynamic var name = ""
    @objc dynamic var time = 0
    @objc dynamic var intensity = 0
    @objc dynamic var deskription = ""
    @objc dynamic var imageURL = ""
    @objc dynamic var featured = false
    var circuits = List<Circuit>()
    var tags = List<Tag>()
    
    // MARK: - Ignored properties
    
    @objc dynamic var numMovements = 0
    @objc dynamic var image: UIImage?
    @objc dynamic var favorite = false
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        name = data["name"] as! String
        time = data["time"] as! Int
        intensity = data["intensity"] as! Int
        deskription = data["description"] as! String
        imageURL = data["image_url"] as! String
        featured = data["featured"] as! Bool
        numMovements = circuits.count
        for circuit in data["circuits"] as! [[String : AnyObject]] {
            circuits.append(Circuit(data: circuit))
        }
        for tag in data["tags"] as! [[String : String]] {
            tags.append(Tag(data: tag))
        }
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["numMovements", "image", "favorite"]
    }
    
    // MARK: - Methods
    
    func loadImage(_ completion: @escaping () -> Void) {
        // first check in cache, if not there, retrieve from s3
        ImageCache.default.retrieveImage(forKey: name, options: nil) { image, type in
            if let image = image {
                self.image = image
                completion()
            } else {
                let url = URL(string: self.imageURL)
                ImageDownloader.default.downloadImage(with: url!, retrieveImageTask: nil, options: nil, progressBlock: nil) { (image, error, url, data) in
                    if let image = image {
                        self.image = image
                        ImageCache.default.store(image, forKey: self.name)
                    }
                    completion()
                }
            }
        }
    }
    
}
