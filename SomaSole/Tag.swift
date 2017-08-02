//
//  Tag.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 8/1/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import Foundation
import RealmSwift

enum WorkoutTag: Int {
    case UpperBody, Core, LowerBody, TotalBody
}

class Tag: Object {
    
    dynamic var tag = 0
    
    convenience init(data: [String : String]) {
        self.init()
        
        let tagString = data["name"]!
        
        tag = tagString == "Upper Body" ? 0 : tagString == "Core" ? 1 : tagString == "Lower Body" ? 2 : 3
    }
    
}
