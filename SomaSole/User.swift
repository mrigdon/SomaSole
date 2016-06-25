//
//  User.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

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
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var height: Float?
    var weight: Float?
    var male: Bool?
    var dateOfBirth: NSDate?
    var activities: [Int]?
    var goals: [Int]?
    var profileImage: UIImage?
    var uid: String?
    var favoriteWorkoutKeys = [String]()
    var favoriteWorkouts = [Workout]()
    var favoriteVideoKeys = [String]()
    var favoriteVideos = [Video]()
    var facebookUser = false
    var premium = false
    
    static func populateFields(data: Dictionary<String, AnyObject>) {
        User.sharedModel.firstName = data["firstName"] as? String
        User.sharedModel.lastName = data["lastName"] as? String
        User.sharedModel.email = data["email"] as? String
        User.sharedModel.password = data["password"] as? String
        User.sharedModel.height = data["height"] as? Float
        User.sharedModel.weight = data["weight"] as? Float
        User.sharedModel.male = data["male"] as? Bool
        User.sharedModel.activities = data["activities"] as? [Int]
        User.sharedModel.goals = data["goals"] as? [Int]
        User.sharedModel.uid = data["uid"] as? String
        User.sharedModel.premium = data["premium"] as! Bool
        User.sharedModel.facebookUser = data["facebook"] as! Bool
        User.sharedModel.password = data["password"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyy"
        User.sharedModel.dateOfBirth = formatter.dateFromString((data["dateOfBirth"] as? String)!)
        
        let imageString = data["profileImageString"] as? String
        let imageData = NSData(base64EncodedString: imageString!, options: .IgnoreUnknownCharacters)
        User.sharedModel.profileImage = UIImage(data: imageData!)
        
        if let favoriteWorkoutKeys = data["favoriteWorkoutKeys"] as? [String] {
            User.sharedModel.favoriteWorkoutKeys = favoriteWorkoutKeys
        }
        
        if let favoriteVideoKeys = data["favoriteVideoKeys"] as? [String] {
            User.sharedModel.favoriteVideoKeys = favoriteVideoKeys
        }
    }
    
    static func stringFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.stringFromDate(date)
    }
    
    static func data() -> Dictionary<String, AnyObject> {
        let user = User.sharedModel
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let userData: Dictionary<String, AnyObject> = [
            "uid": user.uid!,
            "firstName": user.firstName!,
            "lastName": user.lastName!,
            "email": user.email!,
            "height": user.height!,
            "weight": user.weight!,
            "male": user.male!,
            "dateOfBirth": User.stringFromDate(user.dateOfBirth!),
            "activities": user.activities!,
            "goals": user.goals!,
            "profileImageString": user.profileImageString(),
            "favoriteWorkoutKeys": user.favoriteWorkoutKeys,
            "favoriteVideoKeys": user.favoriteVideoKeys,
            "premium": user.premium,
            "facebook": user.facebookUser,
            "password": user.password!
        ]
        
        return userData
    }
    
    static func saveToUserDefaults() {
        NSUserDefaults.standardUserDefaults().setObject(User.data(), forKey: "userData")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func profileImageString() -> String {
        let imageData = UIImageJPEGRepresentation(self.profileImage!, 0.0)
        
        return imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
    func saveToFirebase() {
        FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(uid).setValue(User.data())
    }

}
