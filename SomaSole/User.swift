//
//  User.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AWSS3
import RealmSwift

extension String {
    var base64Image: UIImage {
        let imageData = NSData(base64EncodedString: self, options: .IgnoreUnknownCharacters)
        return UIImage(data: imageData!)!
    }
}

extension UIImage {
    var base64String: String {
        let imageData = UIImageJPEGRepresentation(self, 1.0)
        return imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
}

enum Activity {
    case Climbing
    case Basketball
    case Football
    case Skiing
    case Baseball
    case Tennis
    case Soccer
    case Hockey
    case Surfing
    case Yoga
    case Cycling
    case Swimming
    case Golf
    case MMA
    case Rowing
    case Boxing
    case Track
    case Other
}

enum Goal {
    case Flexibility
    case Functionality
    case Strength
    case Power
    case Toning
    case WeightLoss
}

class User: NSObject {
    
    static var sharedModel = User()
    
    // required
    var uid = ""
    var firstName = ""
    var lastName = ""
    var email = ""
    var password = ""
    var height: Float = 0
    var weight: Float = 0
    var male = false
    var dateOfBirth = NSDate()
    var profileImage = UIImage(named: "profile")!
    var facebook = false
    var premium = false
    var stripeID = ""
    var trialEligible = true
    
    // optional
    var activities = [Int]()
    var goals = [Int]()
    var favoriteWorkoutKeys = [String]()
    var favoriteWorkouts = [Workout]()
    var favoriteVideoKeys = [String]()
    var favoriteVideos = [Video]()
    
    override init() {
        super.init()
    }
    
    init(uid: String, data: [String:AnyObject]) {
        // required
        self.uid = uid
        self.firstName = data["firstName"] as! String
        self.lastName = data["lastName"] as! String
        self.email = data["email"] as! String
        self.height = data["height"] as! Float
        self.weight = data["weight"] as! Float
        self.male = data["male"] as! Bool
        self.dateOfBirth = (data["dateOfBirth"] as! String).dateOfBirthValue
        self.facebook = data["facebook"] as! Bool
        self.premium = data["premium"] as! Bool
        self.stripeID = data["stripeID"] as! String
        self.trialEligible = data["trialEligible"] as! Bool
        
        // optional
        if let activities = data["activities"] as? [Int] {
            self.activities = activities
        }
        if let goals = data["goals"] as? [Int] {
            self.goals = goals
        }
        if let favoriteWorkoutKeys = data["favoriteWorkoutKeys"] as? [String] {
            self.favoriteWorkoutKeys = favoriteWorkoutKeys
        }
        if let favoriteVideoKeys = data["favoriteVideoKeys"] as? [String] {
            self.favoriteVideoKeys = favoriteVideoKeys
        }
    }
    
    func dict() -> [String:AnyObject] {
        let data: [String:AnyObject] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "height": height,
            "weight": weight,
            "male": male,
            "dateOfBirth": dateOfBirth.simpleString,
            "facebook": facebook,
            "premium": premium,
            "stripeID": stripeID,
            "trialEligible": trialEligible,
            "activities": activities,
            "goals": goals,
            "favoriteWorkoutKyes": favoriteWorkoutKeys,
            "favoriteVideoKeys": favoriteVideoKeys
        ]
        
        return data
    }
    
    func uploadProfileImage() {
        let imageData = UIImageJPEGRepresentation(profileImage, 0.6)
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("temp")
        imageData?.writeToURL(fileURL, atomically: true)
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = "somasole/profile_pictures"
        uploadRequest.key = uid
        uploadRequest.body = fileURL
        AWSS3TransferManager.defaultS3TransferManager().upload(uploadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { task -> AnyObject? in
            if let error = task.error {
                print("error uploading image: \(error.code)")
            } else {
                print("successfully uploaded image")
            }
            
            return nil
        })
    }
    
    func downloadProfileImage(completion: () -> Void) {
        // first try from realm
        let realm = try! Realm()
        let realmImage = realm.objects(ROImage).filter("title = '\(uid)'")
        
        // get from s3 if not in realm, then add to realm
        if realmImage.count != 0 {
            profileImage = UIImage(data: realmImage[0].data)!
            completion()
        } else {
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            let downloadFileString = "\(uid)"
            let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("downloaded-" + downloadFileString)
            let downloadRequest = AWSS3TransferManagerDownloadRequest()
            downloadRequest.bucket = "somasole/profile_pictures"
            downloadRequest.key = downloadFileString
            downloadRequest.downloadingFileURL = downloadingFileURL
            
            // download from s3
            transferManager.download(downloadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { task -> AnyObject? in
                
                if task.error == nil {
                    let imageData = NSData(contentsOfURL: downloadingFileURL)
                    self.profileImage = UIImage(data: imageData!)!
                    
                    // cache to realm
                    let rImage = ROImage()
                    rImage.title = self.uid
                    rImage.data = imageData!
                    try! realm.write {
                        realm.add(rImage)
                    }
                }
                completion()
                
                return nil
            })
        }
    }

}
