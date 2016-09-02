//
//  QuickStartImageView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/31/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class QuickStartImageView: UIImageView {

    var workout: Workout?

}

class QuickStartView: UIView {
    
    var workout: Workout?
    var subview: UIView? {
        get {
            return subviews.count == 0 ? nil : subviews[0]
        }
        set(view) {
            self.addSubview(view!)
            view!.snp_makeConstraints(closure: { make in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.bottom.equalTo(self)
            })
        }
    }
    
}
