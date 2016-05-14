//
//  MovementDescriptionCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/14/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class MovementDescriptionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    
    func setConstraints() {
        titleLabelTopConstraint.constant = 4
    }
}
