//
//  Video.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/4/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class Video: NSObject {

    var id = ""
    var title = ""
    var time = 0
    var videoDescription = ""
    var favorite = false
    var free = false
    var image = UIImage()
    
    init(id: String, title: String) {
        super.init()
        self.id = id
        self.title = title
    }
}
