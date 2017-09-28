//
//  Movement.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/31/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import UIKit
//import RealmSwift

//class Movement: Object {
class Movement: NSObject {

    // MARK: - Object properties
    
    @objc dynamic var time = 0
    @objc dynamic var deskription = ""
    @objc dynamic var title = ""
    
    // MARK: - Ignored properties
    
    @objc dynamic var finished = false
    
    @objc dynamic var image: UIImage {
        return UIImage(named: title)!
    }
    
    @objc dynamic var gif: Data {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "\(title).gif", ofType: nil)!)
        return (try! Data(contentsOf: url))
    }
    
    // MARK: - Initializers
    
    convenience init(data: [String : AnyObject]) {
        self.init()
        
        time = data["time"] as? Int ?? 0
        title = data["title"] as! String
        deskription = data["description"] as? String ?? ""
    }
    
    // MARK: - Overridden methods
    
//    override static func ignoredProperties() -> [String] {
//        return ["image", "gif", "finished"]
//    }
    
}
