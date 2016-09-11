//
//  ContainerView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/31/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewWithConstraints(view: UIView, height: Int?, width: Int?, top: Int?, left: Int?, right: Int?, bottom: Int?) {
        self.addSubview(view)
        view.snp_makeConstraints(closure: { make in
            if let height = height {
                make.height.equalTo(height)
            }
            if let width = width {
                make.width.equalTo(width)
            }
            if let top = top {
                make.top.equalTo(self).offset(top)
            }
            if let left = left {
                make.left.equalTo(self).offset(left)
            }
            if let right = right {
                make.right.equalTo(self).offset(-right)
            }
            if let bottom = bottom {
                make.bottom.equalTo(self).offset(-bottom)
            }
        })
    }
}

protocol ContainerViewDelegate {
    func didAddToView(view: UIView)
}

class ContainerView: UIView {
    
    var delegate: ContainerViewDelegate?
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
            delegate?.didAddToView(self)
        }
    }
    
}

class VideoContainerView: ContainerView {
    
    var video: Video?
    
}

class WorkoutContainerView: ContainerView {
    
    var workout: Workout?
    
}
