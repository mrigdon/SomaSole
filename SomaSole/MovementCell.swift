//
//  MovementCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/2/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class MovementCell: UITableViewCell {
    
    // constants
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    // variables
    var movement: (Movement, Int)?

    // outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.progressViewWidth.constant = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
