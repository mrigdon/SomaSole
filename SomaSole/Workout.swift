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

enum WorkoutIndex: Int {
    case AbShred, AnchorAbs, Armageddon, BackToBack, BootyBlaster, BoulderShoulders, CoolDown, GetFunctional, GroundAttack, Intensity, JumpTraining, LeanLegs, Obliques, Plank, PowerUp, PreParty, Stretch, Sweat, UpperBodyBlast
}

enum WorkoutTag: Int {
    case Core, UpperBody, LowerBody, TotalBody
}

class Movement: NSObject {
    
    static var sharedMovements = [Movement]()

    var title: String
    var image: UIImage?
    var time: Int?
    var movementDescription: String?
    var finished = false
    
    init(title: String, time: Int) {
        self.title = title
        self.time = time
    }
    
    init(data: [String:String]) {
        self.title = data["title"]!
        self.movementDescription = data["description"]
    }
    
    func loadImage(completion: () -> Void) {
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let downloadFileString = self.title + ".jpg"
        let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("downloaded-" + downloadFileString)
        let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = "somasole/movements/jpg"
        downloadRequest.key = downloadFileString
        downloadRequest.downloadingFileURL = downloadingFileURL
        
        transferManager.download(downloadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { task -> AnyObject? in
            
            if task.result != nil {
                let data = NSData(contentsOfURL: downloadingFileURL)
                self.image =  UIImage(data: data!)!
                completion()
            }
            
            return nil
        })
    }

}

class Circuit: NSObject {
    
    var numSets: Int
    var currentSet: Int
    var movements: [Movement] = []
    
    init(data: [String:AnyObject]) {
        self.numSets = data["sets"] as! Int
        self.currentSet = 1
        
        let movementsData = data["movements"] as! [[String:Int]]
        for movementData in movementsData {
            let movement = Movement(title: movementData.first!.0, time: movementData.first!.1)
            movements.append(movement)
        }
    }
    
}

class Workout: NSObject {
    
    var index: WorkoutIndex
    var image: UIImage
    var name: String
    var time: Int
    var intensity: Int
    var workoutDescription: String
    var circuits: [Circuit] = []
    var tags = [WorkoutTag]()
    
    init(index: Int, data: [String:AnyObject]) {
        self.index = WorkoutIndex(rawValue: index)!
        self.name = data["name"] as! String
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
