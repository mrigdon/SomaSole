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
    
    static func populateFields(data: Dictionary<String, AnyObject>) {
        let user = User.sharedModel
        
        user.firstName = data["firstName"] as? String
        user.lastName = data["lastName"] as? String
        user.email = data["email"] as? String
        user.height = data["height"] as? Float
        user.weight = data["weight"] as? Float
        user.male = data["male"] as? Bool
        user.activities = data["activities"] as? [Int]
        user.goals = data["goals"] as? [Int]
        user.uid = data["uid"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyy"
        user.dateOfBirth = formatter.dateFromString((data["dateOfBirth"] as? String)!)
    }
    
    static func printAllFields() {
        print(User.sharedModel.firstName)
        print(User.sharedModel.lastName)
        print(User.sharedModel.email)
        print(User.sharedModel.password)
        print(User.sharedModel.height)
        print(User.sharedModel.weight)
        print(User.sharedModel.male)
        print(User.sharedModel.dateOfBirth)
        print(User.sharedModel.activities)
        print(User.sharedModel.goals)
    }

}
