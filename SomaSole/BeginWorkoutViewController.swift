//
//  BeginWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/2/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class BeginWorkoutViewController: UIViewController {
    
    // constants
    let workoutImageHeight: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    
    // variables
    var workout: Workout?
    var movementIndex = 0

    // outlets
    @IBOutlet weak var workoutImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // methods
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func loadMovements() {
        startProgressHud()
        for circuit in workout!.circuits {
            for movement in circuit.movements {
                FirebaseManager.sharedRootRef.childByAppendingPath("movements").childByAppendingPath(String(movement.index)).observeEventType(.Value, withBlock: { snapshot in
                    movement.title = snapshot.value["title"] as! String
                    movement.movementDescription = snapshot.value["description"] as? String
                    movement.decodeImage(snapshot.value["jpg"] as! String)
                    movement.loadGif({
                        self.movementIndex += 1
                        if self.movementIndex == self.workout!.numMovements {
                            self.stopProgressHud()
                        }
                    })
                })
            }
        }
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.workoutImageViewHeight.constant = self.workoutImageHeight
        self.workoutImageView.image = workout!.image
        self.nameLabel.text = self.workout!.name
        self.timeLabel.text = "\(self.workout!.time) minutes"
        self.intensityLabel.text = "\(self.workout!.intensity)"
        self.descriptionLabel.text = self.workout!.workoutDescription
        
        self.loadMovements()
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
