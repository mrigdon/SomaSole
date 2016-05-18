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
    
    // outlets
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var workoutImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    // methods
    private func beginWorkout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewControllerWithIdentifier("InWorkoutViewController") as! InWorkoutViewController
        destVC.workout = self.workout
        self.presentViewController(destVC, animated: true, completion: {
            self.countdownStarted = false
            self.timer = 3
            self.countdownLabel.text = "3"
        })
    }
    
    private func beginCountdown() {
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
                        }
                        else {
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
