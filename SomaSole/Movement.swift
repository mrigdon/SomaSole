//
//  Movement.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/19/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import RealmSwift

class Movement: NSObject {
    
    static var sharedMovements = [Movement]()
    
    var title: String = ""
    var index: Int?
    var image: UIImage?
    var gif: NSData?
    var time: Int?
    var movementDescription: String?
    var finished = false
    
    init(index: Int, time: Int) {
        self.index = index
        self.time = time
    }
    
    init(index: Int, data: [String:String]) {
        self.index = index
        self.title = data["title"]!
        self.movementDescription = data["description"]!
    }
    
    init(data: [String : AnyObject]) {
        time = data["time"] as? Int
        title = data["title"] as! String
        movementDescription = data["description"] as? String
    }
    
    func decodeImage(imageString: String) {
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        image = UIImage(data: decodedData!)
    }
    
}
