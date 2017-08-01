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
    var setupIndex = 0
    var movementsLoaded = false
    var setupsLoaded = false

    // outlets
    @IBOutlet weak var workoutImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    // methods
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func loadMovements() {
//        startProgressHud()
//        for circuit in workout!.circuits {
//            let length = circuit.setup.long ? "long" : "short"
//            circuit.setup.image = UIImage(named: "setup\(circuit.setup.imageIndex)\(length)")
//            
//            for movement in circuit.movements {
//                FirebaseManager.sharedRootRef.child("movements").child(String(movement.index)).observeEventType(.Value, withBlock: { snapshot in
//                    movement.title = snapshot.value!["title"] as! String
//                    movement.movementDescription = snapshot.value!["description"] as? String
//                    let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("\(movement.title).gif", ofType: nil)!)
//                    movement.gif = NSData(contentsOfURL: url)
//                    self.movementIndex += 1
//                    if self.movementIndex == self.workout!.numMovements {
//                        self.stopProgressHud()
//                    }
//                })
//            }
//        }
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
        self.timeLabel.text = "\(Int(self.workout!.time / 60)) minutes"
        self.intensityLabel.text = "\(self.workout!.intensity)"
        self.descriptionLabel.editable = true
        self.descriptionLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        self.descriptionLabel.editable = false
        self.descriptionLabel.text = self.workout!.deskription
        
        self.loadMovements()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.descriptionLabel.setContentOffset(CGPointZero, animated: false)
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
