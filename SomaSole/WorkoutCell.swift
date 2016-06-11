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
        starButton.fillColor = User.sharedModel.favoriteWorkouts.contains(workout!.index) ? UIColor.goldColor() : UIColor.clearColor()
        starButton.config()
    }
    
    // action
    @IBAction func tappedStar(sender: AnyObject) {
        let starButton = sender as! IndexedStarButton
        if User.sharedModel.favoriteWorkouts.contains(workout!.index) {
            let indexInArray = User.sharedModel.favoriteWorkouts.indexOf(workout!.index)
            User.sharedModel.favoriteWorkouts.removeAtIndex(indexInArray!)
            print("here")
            FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).childByAppendingPath("favoriteWorkouts").setValue(User.sharedModel.favoriteWorkouts)
            User.saveToUserDefaults()
            starButton.fillColor = UIColor.clearColor()
            workout!.favorite = false
        }
        else {
            User.sharedModel.favoriteWorkouts.append(workout!.index)
            FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).childByAppendingPath("favoriteWorkouts").setValue(User.sharedModel.favoriteWorkouts)
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
