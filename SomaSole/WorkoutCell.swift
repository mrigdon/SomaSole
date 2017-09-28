//
//  WorkoutCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/21/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import EPShapes
//import SnapKit

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class WorkoutOverlayCell: UITableViewCell {
    
    // constants
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.main.bounds.width
    
    // variables
    var overlayView = UIView()
    var circleView = UIView()
    var lockImageView = UIImageView(image: UIImage(named: "lock"))
    
    // methods
    func setPurchaseOverlay() {
        DispatchQueue.main.async(execute: {
            // overlay view
            self.addSubview(self.overlayView)
//            self.overlayView.snp_makeConstraints { make in
//                make.top.equalTo(self)
//                make.right.equalTo(self)
//                make.bottom.equalTo(self)
//                make.left.equalTo(self)
//            }
            self.bringSubview(toFront: self.overlayView)
            
            // circle view
            self.addSubview(self.circleView)
//            self.circleView.snp_makeConstraints { make in
//                make.center.equalTo(self)
//                make.width.equalTo(100)
//                make.height.equalTo(100)
//            }
            self.bringSubview(toFront: self.circleView)
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        circleView.backgroundColor = UIColor.white
        circleView.layer.cornerRadius = 50
        circleView.addSubview(lockImageView)
//        lockImageView.snp_makeConstraints { make in
//            make.center.equalTo(self.circleView)
//            make.height.equalTo(60)
//            make.width.equalTo(60)
//        }
        setPurchaseOverlay()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
