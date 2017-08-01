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
    
    // MARK: - Ignored properties
    
    dynamic var numMovements = 0
    dynamic var image: UIImage?
    dynamic var favorite = false
    dynamic var circuits = [Circuit]()
    var tags = [WorkoutTag]()
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        name = data["name"] as! String
        time = data["time"] as! Int
        intensity = data["intensity"] as! Int
        deskription = data["description"] as! String
        imageURL = data["image_url"] as! String
        circuits = (data["circuits"] as! [[String : AnyObject]]).map { Circuit(data: $0) }
        numMovements = circuits.count
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["numMovements", "image", "favorite", "circuits", "movements"]
    }
    
    // MARK: - Methods
    
    func loadImage(completion: () -> Void) {
        // first check in cache, if not there, retrieve from s3
        ImageCache.defaultCache.retrieveImageForKey(imageURL, options: nil) { image, type in
            if let image = image {
                self.image = image
                completion()
            } else {
                let url = NSURL(string: self.imageURL)
                ImageDownloader.defaultDownloader.downloadImageWithURL(url!, progressBlock: nil, completionHandler: { (image, error, url, data) in
                    self.image = image!
                    completion()
                    ImageCache.defaultCache.storeImage(image!, forKey: self.imageURL)
                })
            }
        }
    }
    
}
