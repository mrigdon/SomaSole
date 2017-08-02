//
//  Workout.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import Foundation
import RealmSwift
import Kingfisher

enum WorkoutTag: Int {
    case UpperBody, Core, LowerBody, TotalBody
}

class Workout: Object {
    
    static var sharedFavorites = [Workout]()
    
    // MARK: - Object properties
    
    dynamic var name = ""
    dynamic var time = 0
    dynamic var intensity = 0
    dynamic var deskription = ""
    dynamic var imageURL = ""
    var circuits = List<Circuit>()
    var tags = [WorkoutTag]()
    
    // MARK: - Ignored properties
    
    dynamic var numMovements = 0
    dynamic var image: UIImage?
    dynamic var favorite = false
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        name = data["name"] as! String
        time = data["time"] as! Int
        intensity = data["intensity"] as! Int
        deskription = data["description"] as! String
        imageURL = data["image_url"] as! String
        numMovements = circuits.count
        for circuit in data["circuits"] as! [[String : AnyObject]] {
            circuits.append(Circuit(data: circuit))
        }
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["numMovements", "image", "favorite", "tags"]
    }
    
    // MARK: - Methods
    
    func loadImage(completion: () -> Void) {
        // first check in cache, if not there, retrieve from s3
        ImageCache.defaultCache.retrieveImageForKey(name, options: nil) { image, type in
            if let image = image {
                self.image = image
                completion()
            } else {
                let url = NSURL(string: self.imageURL)
                ImageDownloader.defaultDownloader.downloadImageWithURL(url!, progressBlock: nil, completionHandler: { (image, error, url, data) in
                    self.image = image!
                    ImageCache.defaultCache.storeImage(image!, forKey: self.name)
                    completion()
                })
            }
        }
    }
    
}
