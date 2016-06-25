//
//  FinishedWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/13/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import FBSDKShareKit

class FinishedWorkoutViewController: UIViewController {
    
    // constants
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    
    // variables
    var workout: Workout!

    // outlets
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var workoutImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareButton: FBSDKShareButton!
    
    // actions
    @IBAction func tappedShare(sender: AnyObject) {
        
    }
    
    @IBAction func tappedBackToWorkouts(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewControllerWithIdentifier("MainViewController")
        presentViewController(mainVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // workout image view
        workoutImageViewHeight.constant = workoutCellSize
        self.workoutImageView.image = self.workout!.image
        let shareContent = FBSDKShareLinkContent()
        shareContent.contentDescription = "test"
        shareButton.shareContent = shareContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
