//
//  LabelCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
