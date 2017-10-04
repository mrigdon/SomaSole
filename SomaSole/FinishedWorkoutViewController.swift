//
//  FinishedWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/13/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class FinishedWorkoutViewController: UIViewController {
    
    // constants
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.main.bounds.width
    
    // variables
    var workout: Workout!

    // outlets
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var workoutImageViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // workout image view
        workoutImageViewHeight.constant = workoutCellSize
        self.workoutImageView.image = self.workout!.image
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! UITabBarController
        destVC.selectedIndex = 1
    }

}
