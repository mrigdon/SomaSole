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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! UITabBarController
        destVC.selectedIndex = 1
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
