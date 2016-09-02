//
//  VideoCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/28/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import SnapKit

class VideoCell: UITableViewCell {
    
    // variables
    var video: Video?

    // outlets
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starButton: IndexedStarButton!
    @IBOutlet weak var videoImageViewHeight: NSLayoutConstraint!
    
    // method
    func setStarFill() {
        starButton.fillColor = Video.sharedFavorites.contains(video!) ? UIColor.goldColor() : UIColor.clearColor()
        starButton.config()
    }
    
    // actions
    @IBAction func tappedStar(sender: AnyObject) {
        let starButton = sender as! IndexedStarButton
        if Video.sharedFavorites.contains(video!) {
            Video.sharedFavorites.removeAtIndex(Video.sharedFavorites.indexOf(video!)!)
            var videoKeys = [String]()
            for video in Video.sharedFavorites {
                videoKeys.append(video.title)
            }
            NSUserDefaults.standardUserDefaults().setObject(videoKeys, forKey: "favoriteVideoKeys")
            NSUserDefaults.standardUserDefaults().synchronize()
            starButton.fillColor = UIColor.clearColor()
            video!.favorite = false
        } else {
            Video.sharedFavorites.append(video!)
            var videoKeys = [String]()
            for video in Video.sharedFavorites {
                videoKeys.append(video.title)
            }
            NSUserDefaults.standardUserDefaults().setObject(videoKeys, forKey: "favoriteVideoKeys")
            NSUserDefaults.standardUserDefaults().synchronize()
            starButton.fillColor = UIColor.goldColor()
            video!.favorite = true
        }
        starButton.config()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        videoImageViewHeight.constant = (UIScreen.mainScreen().bounds.width - 16) * (9/16)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class VideoOverlayCell: UITableViewCell {
    
    // variables
    var overlayView = UIView()
    var circleView = UIView()
    var lockImageView = UIImageView(image: UIImage(named: "lock"))
    var video: Video?
    
    // outlets
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starButton: IndexedStarButton!
    @IBOutlet weak var videoImageViewHeight: NSLayoutConstraint!
    
    // methods
    func setStarFill() {
        starButton.fillColor = Video.sharedFavorites.contains(video!) ? UIColor.goldColor() : UIColor.clearColor()
        starButton.config()
    }
    
    func setPurchaseOverlay() {
        dispatch_async(dispatch_get_main_queue(), {
            // overlay view
            self.addSubview(self.overlayView)
            self.overlayView.snp_makeConstraints { make in
                make.top.equalTo(self.snp_top)
                make.right.equalTo(self.snp_right)
                make.bottom.equalTo(self.snp_bottom)
                make.left.equalTo(self.snp_left)
            }
            self.bringSubviewToFront(self.overlayView)
            
            // circle view
            self.addSubview(self.circleView)
            self.circleView.snp_makeConstraints { make in
                make.center.equalTo(self)
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            self.bringSubviewToFront(self.circleView)
        })
    }
    
    // actions
    @IBAction func tappedStar(sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        videoImageViewHeight.constant = (UIScreen.mainScreen().bounds.width - 16) * (9/16)
        overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = 50
        circleView.addSubview(lockImageView)
        lockImageView.snp_makeConstraints { make in
            make.center.equalTo(self.circleView)
            make.center.height.equalTo(60)
            make.center.width.equalTo(60)
        }
        setPurchaseOverlay()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
