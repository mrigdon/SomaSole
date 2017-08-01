//
//  Movement.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import Foundation
import RealmSwift

class Movement: Object {
    
    // MARK: - Object properties
    
    dynamic var time = 0
    dynamic var deskription = ""
    dynamic var title = ""
    
    // MARK: - Ignored properties
    
    dynamic var finished = false
    
    dynamic var image: UIImage {
        return UIImage(named: title)!
    }
    
    dynamic var gif: NSData {
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("\(title).gif", ofType: nil)!)
        return NSData(contentsOfURL: url)!
    }
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        time = data["time"] as? Int ?? 0
        title = data["title"] as! String
        deskription = data["description"] as? String ?? ""
    }
    
    // MARK: - Overridden methods
    
    override static func ignoredProperties() -> [String] {
        return ["image", "gif", "finished"]
    }
    
}
