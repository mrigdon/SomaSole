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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let video = video {
            playerView.loadWithVideoId(video.id)
            nameLabel.text = video.title
            timeLabel.text = "\(video.time) minutes"
            descriptionLabel.text = video.videoDescription
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()
        }
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
