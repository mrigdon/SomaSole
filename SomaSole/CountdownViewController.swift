//
//  CountdownViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/2/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {

    // constants
    let workoutImageHeight: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    
    // variables
    var workout: Workout?
    var timer = 3
    var countdownStarted = false
    var customPace = false
    
    // outlets
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var workoutImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    // methods
    private func beginWorkout() {
        self.countdownStarted = false
        self.timer = 3
        self.countdownLabel.text = "3"
        self.countdownLabel.alpha = 0
        let segueID = customPace ? "customSegue" : "guidedSegue"
        self.performSegueWithIdentifier(segueID, sender: self)
    }
    
    private func beginCountdown() {
        countdownLabel.alpha = 1
        UIView.animateWithDuration(0.5, animations: {
                self.countdownLabel.alpha = 0
            }, completion: { finished in
                self.timer -= 1
                self.countdownLabel.text = "\(self.timer)"
                UIView.animateWithDuration(0.5, animations: {
                        self.countdownLabel.alpha = 1
                    }, completion: { finished in
                        if self.timer > 0 {
                            self.beginCountdown()
                        } else {
                            self.beginWorkout()
                        }
                    }
                )
            }
        )
    }
    
    // actions
    @IBAction func tappedStart(sender: AnyObject) {
        if !countdownStarted {
            countdownStarted = true
            customPace = false
            self.beginCountdown()
        }
    }
    
    @IBAction func tappedGoAtYourOwnPace(sender: AnyObject) {
        if !countdownStarted {
            countdownStarted = true
            customPace = true
            self.beginCountdown()
        }
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.workoutImageViewHeight.constant = self.workoutImageHeight
        self.workoutImageView.image = self.workout!.image
        self.timeLabel.text = "\(self.workout!.time) minutes"
        countdownLabel.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        countdownLabel.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let rootVC = segue.destinationViewController as! UINavigationController
        if segue.identifier == "guidedSegue" {
            (rootVC.viewControllers.first as! GuidedWorkoutViewController).workout = workout
        } else {
            (rootVC.viewControllers.first as! CustomPaceViewController).workout = workout
        }
    }

}
