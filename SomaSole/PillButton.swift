//
//  PillButton.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

@IBDesignable
class PillButton: UIButton {
    
    let opaqueBlackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    let opaqueBlueColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
    
    var selectedByUser: Bool = false
    var activity: Activity?
    var goal: Goal?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = opaqueBlackColor
        self.layer.cornerRadius = 5
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if !selectedByUser {
            self.backgroundColor = opaqueBlueColor
            selectedByUser = true
        }
        else {
            self.backgroundColor = opaqueBlackColor
            selectedByUser = false
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
