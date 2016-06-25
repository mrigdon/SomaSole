//
//  WorkoutCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/21/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AWSS3
import EPShapes
import Firebase

extension UIColor {
    static func goldColor() -> UIColor {
        return UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0)
    }
}

class IndexedStarButton: StarButton {
    
    var index: Int?
    
}

class WorkoutCell: UITableViewCell {
    
    // constants
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    
    // variables
    var workout: Workout?
    
    // outlets
    @IBOutlet weak var starButton: IndexedStarButton!
    
    // methods
    func setStarFill() {
        starButton.fillColor = User.sharedModel.favoriteWorkoutKeys.contains(workout!.name) ? UIColor.goldColor() : UIColor.clearColor()
        starButton.config()
    }
    
    // action
    @IBAction func tappedStar(sender: AnyObject) {
        let starButton = sender as! IndexedStarButton
        if User.sharedModel.favoriteWorkoutKeys.contains(workout!.name) {
            User.sharedModel.favoriteWorkouts.removeAtIndex(User.sharedModel.favoriteWorkouts.indexOf(workout!)!)
            User.sharedModel.favoriteWorkoutKeys.removeAtIndex(User.sharedModel.favoriteWorkoutKeys.indexOf(workout!.name)!)
            FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).childByAppendingPath("favoriteWorkoutKeys").setValue(User.sharedModel.favoriteWorkoutKeys)
            User.saveToUserDefaults()
            starButton.fillColor = UIColor.clearColor()
            workout!.favorite = false
        } else {
            User.sharedModel.favoriteWorkouts.insertAlpha(workout!)
            User.sharedModel.favoriteWorkoutKeys.append(workout!.name)
            FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).childByAppendingPath("favoriteWorkoutKeys").setValue(User.sharedModel.favoriteWorkoutKeys)
            User.saveToUserDefaults()
            starButton.fillColor = UIColor.goldColor()
            workout!.favorite = true
        }
        starButton.config()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
            self.overlayView.mas_makeConstraints { make in
                make.top.equalTo()(self.mas_top)
                make.right.equalTo()(self.mas_right)
                make.bottom.equalTo()(self.mas_bottom)
                make.left.equalTo()(self.mas_left)
            }
            self.bringSubviewToFront(self.overlayView)
            
            // circle view
            self.addSubview(self.circleView)
            self.circleView.mas_makeConstraints { make in
                make.center.equalTo()(self)
                make.width.equalTo()(100)
                make.height.equalTo()(100)
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
        lockImageView.mas_makeConstraints { make in
            make.center.equalTo()(self.circleView)
        }
        setPurchaseOverlay()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
