//
//  IndexedStarButton.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/11/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import EPShapes

class IndexedStarButton: StarButton {
    
    var index: Int?
    
    init() {
        super.init(frame: CGRectZero)
        
        // set properties
//        fillColor = UIColor.goldColor()
        corners = 5
        extrusionPercent = 50
        strokeColor = UIColor.goldColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
