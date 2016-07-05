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
    var video: Video?

    // outlets
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starButton: IndexedStarButton!
    
    // method
    func setStarFill() {
        starButton.fillColor = User.sharedModel.favoriteVideoKeys.contains(video!.id) ? UIColor.goldColor() : UIColor.clearColor()
        starButton.config()
    }
    
    // actions
    @IBAction func tappedStar(sender: AnyObject) {
        let starButton = sender as! IndexedStarButton
        if User.sharedModel.favoriteVideoKeys.contains(video!.id) {
            User.sharedModel.favoriteVideos.removeAtIndex(User.sharedModel.favoriteVideos.indexOf(video!)!)
            User.sharedModel.favoriteVideoKeys.removeAtIndex(User.sharedModel.favoriteVideoKeys.indexOf(video!.id)!)
            FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).childByAppendingPath("favoriteVideoKeys").setValue(User.sharedModel.favoriteVideoKeys)
            NSUserDefaults.standardUserDefaults().setObject(User.sharedModel.dict(), forKey: "userData")
            NSUserDefaults.standardUserDefaults().synchronize()
            starButton.fillColor = UIColor.clearColor()
            video!.favorite = false
        } else {
            User.sharedModel.favoriteVideos.append(video!)
            User.sharedModel.favoriteVideoKeys.append(video!.id)
            FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).childByAppendingPath("favoriteVideoKeys").setValue(User.sharedModel.favoriteVideoKeys)
            NSUserDefaults.standardUserDefaults().setObject(User.sharedModel.dict(), forKey: "userData")
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
    
    // methods
    func setStarFill() {
        starButton.fillColor = User.sharedModel.favoriteVideoKeys.contains(video!.id) ? UIColor.goldColor() : UIColor.clearColor()
        starButton.config()
    }
    
    func setPurchaseOverlay() {
        dispatch_async(dispatch_get_main_queue(), {
            // overlay view
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
        overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = 50
        circleView.addSubview(lockImageView)
        lockImageView.mas_makeConstraints { make in
            make.center.equalTo()(self.circleView)
        }
        setPurchaseOverlay()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
