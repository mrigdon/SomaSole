//
//  VideoCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/28/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoCell: UITableViewCell {

    // outlets
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var buyCircleView: UIView!
    @IBOutlet weak var buyLabel: UILabel!
    
    // methods
    func setPurchaseOverlay() {
        overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        buyCircleView.backgroundColor = UIColor.whiteColor()
        buyCircleView.layer.cornerRadius = buyCircleView.frame.size.width / 2
        buyLabel.textColor = UIColor.blackColor()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
