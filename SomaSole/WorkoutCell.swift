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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // set background image
        let workoutImageView = UIImageView(image: UIImage(named: "boulder_shoulders"))
        self.backgroundView = workoutImageView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
