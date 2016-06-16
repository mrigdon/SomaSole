//
//  VideoCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/28/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Masonry

class VideoCell: UITableViewCell {
    
    // variables
    var overlayView = UIView()
    var circleView = UIView()
    var lockImageView = UIImageView(image: UIImage(named: "lock"))
    var purchaseOverlayAdded = false

    // outlets
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // methods    
    func setPurchaseOverlay(flag: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            if flag && !self.purchaseOverlayAdded {
                // overlay view
                self.purchaseOverlayAdded = true
                self.addSubview(self.overlayView)
                self.overlayView.mas_makeConstraints { make in
                    make.top.equalTo()(self.mas_top)
                    make.right.equalTo()(self.mas_right)
                    make.bottom.equalTo()(self.mas_bottom)
                    make.left.equalTo()(self.mas_left)
                }
                self.bringSubviewToFront(self.overlayView)
                
                // circle view
                self.addSubview(self.circleView)
                self.circleView.mas_makeConstraints { make in
                    make.center.equalTo()(self)
                    make.width.equalTo()(100)
                    make.height.equalTo()(100)
                }
                self.bringSubviewToFront(self.circleView)
            } else {
                self.purchaseOverlayAdded = false
                self.overlayView.removeFromSuperview()
                self.circleView.removeFromSuperview()
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = 50
        circleView.addSubview(lockImageView)
        lockImageView.mas_makeConstraints { make in
            make.center.equalTo()(self.circleView)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
