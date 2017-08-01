//
//  Circuit.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import Foundation
import RealmSwift

class Circuit: Object {
    
    // MARK: - Object properties
    
    dynamic var sets = 0
    dynamic var setup: Setup!
    
    // MARK: - Ignored properties
    
    dynamic var currentSet = 1
    dynamic var movements = [Movement]()
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        sets = data["sets"] as! Int
        movements = (data["movements"] as! [[String : AnyObject]]).map { Movement(data: $0) }
        setup = Setup(data: data["setup"] as! [String : Int])
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["currentSet", "movements"]
    }
    
}
