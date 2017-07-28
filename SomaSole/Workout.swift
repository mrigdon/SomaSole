//
//  Workout.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/25/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase
import SwiftString
import Kingfisher

enum WorkoutTag: Int {
    case UpperBody, Core, LowerBody, TotalBody
}

class Setup: NSObject {
    
    var imageIndex: Int
    var image: UIImage?
    var long: Bool
    
    init(data: [String : Int]) {
        imageIndex = data["legacy_index"]!
        long = Bool(data["length"]!)
    }
}

class Circuit: NSObject {
    
    var numSets: Int
    var currentSet: Int
    var movements: [Movement] = []
    var setup: Setup
    
    init(data: [String:AnyObject]) {
        numSets = data["sets"] as! Int
        currentSet = 1
        movements = (data["movements"] as! [[String : AnyObject]]).map { Movement(data: $0) }
        setup = Setup(data: data["setup"] as! [String : Int])
    }
    
}

class Workout: NSObject {
    
    static var sharedFavorites = [Workout]()
    
    let imageDimensions: Int64 = 1 * 1300 * 670
    
    var image: UIImage?
    var name = ""
    var time = 0
    var intensity = 0
    var workoutDescription = ""
    var circuits = [Circuit]()
    var tags = [WorkoutTag]()
    var numMovements = 0
    var favorite = false
    var free = true
    var imageURL = ""
    
    init(name: String, data: [String:AnyObject]) {
        self.name = name
        self.time = data["time"] as! Int
        self.intensity = data["intensity"] as! Int
        self.workoutDescription = data["description"] as! String
        
        // init circuits
        let circuitsData = data["circuits"] as! [[String:AnyObject]]
        for circuitData in circuitsData {
            let circuit = Circuit(data: circuitData)
            circuits.append(circuit)
            numMovements += circuit.movements.count
        }
        
        // init tags
        let tagsData = data["tags"] as! [Int]
        for tagData in tagsData {
            self.tags.append(WorkoutTag(rawValue: tagData)!)
        }
    }
    
    init(data: [String : AnyObject]) {
        name = data["name"] as! String
        time = data["time"] as! Int
        intensity = data["intensity"] as! Int
        workoutDescription = data["description"] as! String
        imageURL = data["image_url"] as! String
        circuits = (data["circuits"] as! [[String : AnyObject]]).map { Circuit(data: $0) }
        numMovements = circuits.count
    }
    
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
