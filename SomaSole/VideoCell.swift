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
    @IBOutlet weak var tagView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerView.loadWithVideoId("M7lc1UVf-VE")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
