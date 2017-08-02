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
    var movements = List<Movement>()
    
    // MARK: - Ignored properties
    
    dynamic var currentSet = 1
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        sets = data["sets"] as! Int
        setup = Setup(data: data["setup"] as! [String : Int])
        for movement in data["movements"] as! [[String : AnyObject]] {
            movements.append(Movement(data: movement))
        }
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["currentSet"]
    }
    
}
