//
//  WorkoutCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/21/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import EPShapes
import Firebase
import SnapKit

extension UIColor {
    static func goldColor() -> UIColor {
        return UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0)
    }
}

class WorkoutCell: UITableViewCell {
    
    var workout: Workout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class WorkoutOverlayCell: UITableViewCell {
    
    // constants
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    
    // variables
    var overlayView = UIView()
    var circleView = UIView()
    var lockImageView = UIImageView(image: UIImage(named: "lock"))
    
    // methods
    func setPurchaseOverlay() {
        dispatch_async(dispatch_get_main_queue(), {
            // overlay view
            self.addSubview(self.overlayView)
            self.overlayView.snp_makeConstraints { make in
                make.top.equalTo(self)
                make.right.equalTo(self)
                make.bottom.equalTo(self)
                make.left.equalTo(self)
            }
            self.bringSubviewToFront(self.overlayView)
            
            // circle view
            self.addSubview(self.circleView)
            self.circleView.snp_makeConstraints { make in
                make.center.equalTo(self)
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            self.bringSubviewToFront(self.circleView)
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = 50
        circleView.addSubview(lockImageView)
        lockImageView.snp_makeConstraints { make in
            make.center.equalTo(self.circleView)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        setPurchaseOverlay()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
