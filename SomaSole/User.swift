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
    var activities: [Activity]?
    var goals: [Goal]?

}
