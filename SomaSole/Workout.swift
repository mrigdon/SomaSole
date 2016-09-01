//
//  Workout.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/25/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

enum WorkoutTag: Int {
    case UpperBody, Core, LowerBody, TotalBody
}

class Setup: NSObject {
    
    var imageIndex: Int
    var image: UIImage?
    var long: Bool
    
    init(data: [String:Int]) {
        imageIndex = data["index"]!
        long = Bool(data["length"]!)
    }
}

class Circuit: NSObject {
    
    var numSets: Int
    var currentSet: Int
    var movements: [Movement] = []
    var setup: Setup
    
    init(data: [String:AnyObject]) {
        self.numSets = data["sets"] as! Int
        self.currentSet = 1
        
        let movementsData = data["movements"] as! [[String:Int]]
        for movementData in movementsData {
            let indexWithPrefix = movementData.first!.0 as NSString
            let index = Int(indexWithPrefix.substringFromIndex(1))!
            let movement = Movement(index: index, time: movementData.first!.1)
            movements.append(movement)
        }
        
        self.setup = Setup(data: data["setup"] as! [String:Int])
    }
    
}

class Workout: NSObject {
    
    static var sharedFavorites = [Workout]()
    
    var image: UIImage
    var name: String
    var time: Int
    var intensity: Int
    var workoutDescription: String
    var circuits: [Circuit] = []
    var tags = [WorkoutTag]()
    var numMovements = 0
    var favorite = false
    var free = false
    
    init(name: String, data: [String:AnyObject]) {
        self.name = name
        self.time = data["time"] as! Int
        self.intensity = data["intensity"] as! Int
        self.workoutDescription = data["description"] as! String
        
        // init image
        let base64String = data["image"] as! String
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        self.image = UIImage(data: decodedData!)!
        
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
    
}
