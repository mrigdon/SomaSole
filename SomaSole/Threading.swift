//
//  Threading.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 8/1/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import UIKit

class Threading: NSObject {
    
    static func background(block: () -> Void) {
        dispatch_async(dispatch_queue_create("background", nil)) {
            block()
        }
    }
    
    static func main(block: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            block()
        })
    }

}
