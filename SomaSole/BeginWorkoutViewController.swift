//
//  BeginWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/2/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class BeginWorkoutViewController: UIViewController {
    
    // constants
    let workoutImageHeight: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    
    // variables
    var workout: Workout?

    // outlets
    @IBOutlet weak var workoutImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.workoutImageViewHeight.constant = self.workoutImageHeight
        self.workoutImageView.image = UIImage(named: self.workout!.imageName)
        self.nameLabel.text = self.workout!.name
        self.timeLabel.text = "\(self.workout!.time) minutes"
        self.intensityLabel.text = "\(self.workout!.intensity)"
        self.descriptionLabel.text = self.workout!.workoutDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        let destVC = segue.destinationViewController as! CountdownViewController
        
        // Pass the selected object to the new view controller.
        destVC.workout = self.workout
    }

}
