//
//  Workout.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/25/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AWSS3
import Firebase
import RealmSwift

enum WorkoutTag: Int {
    case Core, UpperBody, LowerBody, TotalBody
}

class Setup: NSObject {
    
    var imageIndex: Int
    var image: UIImage?
    var long: Bool
    
    init(data: [String:Int]) {
        imageIndex = data["index"]!
        long = Bool(data["index"]!)
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
    
    func loadSetupImage(completion: () -> Void) {
        // first try from realm
        let realm = try! Realm()
        let realmImage = realm.objects(ROImage).filter("title = 'setup\(setup.imageIndex)'")
        
        // get from s3 if not in realm, then add to realm
        if realmImage.count != 0 {
            setup.image = UIImage(data: realmImage[0].data)
            completion()
        } else {
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            let downloadFileString = "setup\(setup.imageIndex).jpg"
            let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("downloaded-" + downloadFileString)
            let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
            downloadRequest.bucket = "somasole/setups"
            downloadRequest.key = downloadFileString
            downloadRequest.downloadingFileURL = downloadingFileURL
            
            transferManager.download(downloadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { task -> AnyObject? in
                
                if task.result != nil {
                    let downloadData = NSData(contentsOfURL: downloadingFileURL)
                    self.setup.image = UIImage(data: downloadData!)
                    completion()
                    
                    // cache to realm
                    let realmImage = ROImage()
                    realmImage.title = "setup\(self.setup.imageIndex)"
                    realmImage.data = downloadData!
                    try! realm.write {
                        realm.add(realmImage)
                    }
                }
                
                return nil
            })
        }
    }
    
}

class Workout: NSObject {
    
    static var sharedWorkouts = [Workout]()
    
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
    
    func loadImage(reloadTableView: () -> Void) {
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let downloadFileString = self.name + ".jpg"
        let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("downloaded-" + downloadFileString)
        let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = "somasole/workouts"
        downloadRequest.key = downloadFileString
        downloadRequest.downloadingFileURL = downloadingFileURL
        
        transferManager.download(downloadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { task -> AnyObject? in
            
            if task.result != nil {
                let data = NSData(contentsOfURL: downloadingFileURL)
                self.image =  UIImage(data: data!)!
                reloadTableView()
            }
            
            return nil
        })
    }
    
    func printAll() {
        print("index: \(index)")
        print("name: \(name)")
        print("time: \(time)")
        print("intensity: \(intensity)")
        print("description: \(workoutDescription)")
    }
}
