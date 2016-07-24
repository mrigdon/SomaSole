//
//  PlayVideoViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/28/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: UIViewController {
    
    // variables
    var video: Video?

    // outlets
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let video = video {
            let playerVars = [
                "modestbranding": 1,
                "showinfo": 0,
                "rel": 0
            ]
            playerView.loadWithVideoId(video.id, playerVars: playerVars)
            nameLabel.text = video.title
            nameLabel.numberOfLines = 0
            nameLabel.sizeToFit()
            timeLabel.text = "\(video.time) minutes"
            descriptionLabel.editable = true
            descriptionLabel.font = UIFont(name: "HelveticaNeue", size: 17)
            descriptionLabel.editable = false
            descriptionLabel.text = video.videoDescription
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.descriptionLabel.setContentOffset(CGPointZero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
