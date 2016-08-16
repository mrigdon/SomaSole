//
//  Video.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/4/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    static var sharedFavorites = [Video]()

    var id = ""
    var title = ""
    var time = 0
    var videoDescription = ""
    var favorite = false
    var free = false
    var image = UIImage()
    
    init(id: String, data: [String:AnyObject]) {
        super.init()
        self.id = id
        self.title = data["title"] as! String
        self.time = data["time"] as! Int
        self.videoDescription = data["description"] as! String
    }
}
