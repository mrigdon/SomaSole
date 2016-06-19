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
    var favorite = false
    var free = false
    
    init(id: String, title: String) {
        super.init()
        self.id = id
        self.title = title
    }
}
