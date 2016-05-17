//
//  WorkoutCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/21/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {
    
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    
    var workout: Workout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func associateWorkout(workout: Workout) {
        self.workout = workout
        let image = UIImage(named: workout.imageName)
        print("\(workout.name): h:\(image!.size.height) w:\(image!.size.width)\n")
        self.backgroundView = UIImageView(image: UIImage(named: workout.imageName))
    }

}
