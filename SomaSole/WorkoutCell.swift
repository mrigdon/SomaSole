//
//  WorkoutCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/21/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import EPShapes

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
