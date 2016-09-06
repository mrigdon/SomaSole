//
//  QuickStartView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/31/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

protocol QuickStartViewDelegate {
    func didAddToView(withFrame frame: CGRect)
}

class QuickStartView: UIView {
    
    var delegate: QuickStartViewDelegate?
    var workout: Workout?
    var subview: UIView? {
        get {
            return subviews.count == 0 ? nil : subviews[0]
        }
        set(view) {
            for v in subviews {
                v.removeFromSuperview()
            }
            
            self.addSubview(view!)
            view!.snp_makeConstraints(closure: { make in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.bottom.equalTo(self)
            })
            delegate?.didAddToView(withFrame: frame)
        }
    }
    
}

class QuickStartImageView: UIImageView {
    
    var workout: Workout?
    
}
