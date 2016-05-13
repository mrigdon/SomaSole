//
//  TagCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/21/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import TagListView

class TagCell: UITableViewCell {
    
    let viewPadding = 8
    let paddingY = 5
    let borderWidth = 1
    let textSize = 14
    let filterTitles = [
        WorkoutTag.UpperBody: "Upper Body",
        WorkoutTag.LowerBody: "Lower Body",
        WorkoutTag.Core: "Core",
        WorkoutTag.TotalBody: "Total Body"
    ]

    @IBOutlet weak var tagListView: TagListView!
    
    func addFilters(filters: [WorkoutTag]) {
        tagListView.removeAllTags()
        
        for filter in filters {
            self.tagListView.addTag(filterTitles[filter]!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // tag list view customization
        tagListView.textFont = UIFont.systemFontOfSize(14)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
