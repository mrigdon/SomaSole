//
//  CustomPaceViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/6/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import MZTimerLabel
import Gifu

class CustomPaceViewController: UIViewController {

    // variables
    var workout: Workout?
    var gifVisible = true
    var timer = MZTimerLabel()
    var currentCircuit: Circuit?
    var movementCounter = 0
    var setCounter = 0
    var circuitCounter = 0
    
    // outlets
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var gifView: AnimatableImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var tipTextView: UITextView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // actions
    @IBAction func tappedX(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] in
            self.gifView.stopAnimatingGIF()
            self.timer.pause()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    @IBAction func tappedInfo(sender: AnyObject) {
        gifView.alpha = gifVisible ? 0 : 1
        tipTextView.alpha = gifVisible ? 1 : 0
        gifVisible = !gifVisible
    }
    
    @IBAction func tappedPrevious(sender: AnyObject) {
        if circuitCounter == 0 && setCounter == 0 && movementCounter == 0 {
            return
        }
        
        movementCounter -= 1
        if movementCounter == -1 {
            setCounter -= 1
            if setCounter == -1 {
                circuitCounter -= 1
                setCounter = workout!.circuits[circuitCounter].numSets - 1
            }
            movementCounter = workout!.circuits[circuitCounter].movements.count
        }
        
        currentCircuit = workout?.circuits[circuitCounter]
        let movement: Movement? = movementCounter == 0 ? nil : currentCircuit!.movements[movementCounter - 1]
        movementLabel.text = movementCounter == 0 ? (setCounter == 0 ? "Setup" : "Rest") : movement!.title
        setLabel.text = "Circuit \(circuitCounter+1)/\(workout!.circuits.count) Set \(setCounter+1)/\(workout!.circuits[circuitCounter].numSets)"
        let imageData = movementCounter == 0 ? (setCounter == 0 ? UIImageJPEGRepresentation(currentCircuit!.setup.image!, 1.0) : NSData(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Rest.gif", ofType: nil)!))) : movement!.gif
        ui {
            self.gifView.animateWithImageData(imageData!)
        }
        tipTextView.text = movementCounter == 0 ? "" : movement!.movementDescription
    }
    
    @IBAction func tappedNext(sender: AnyObject) {
        movementCounter += 1
        if movementCounter == currentCircuit!.movements.count + 1 { // +1 for the setup
            setCounter += 1
            if setCounter == currentCircuit!.numSets {
                circuitCounter += 1
                setCounter = 0
            }
            movementCounter = 0
        }
        
        if circuitCounter == workout!.circuits.count {
            // done with workout
            performSegueWithIdentifier("finishedSegue", sender: self)
            return
        }
        
        currentCircuit = workout?.circuits[circuitCounter]
        let movement: Movement? = movementCounter == 0 ? nil : currentCircuit!.movements[movementCounter - 1] // -1 for the setup
        movementLabel.text = movementCounter == 0 ? (setCounter == 0 ? "Setup" : "Rest") : movement!.title
        setLabel.text = "Circuit \(circuitCounter+1)/\(workout!.circuits.count) Set \(setCounter+1)/\(workout!.circuits[circuitCounter].numSets)"
        let imageData = movementCounter == 0 ? (setCounter == 0 ? UIImageJPEGRepresentation(currentCircuit!.setup.image!, 1.0) : NSData(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Rest.gif", ofType: nil)!))) : movement!.gif
        ui {
            self.gifView.animateWithImageData(imageData!)
        }
        tipTextView.text = movementCounter == 0 ? "" : movement!.movementDescription
    }
    
    // methods
    private func ui (task: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            task()
        })
    }
    
    private func beginWorkout() {
        currentCircuit = workout?.circuits[0]
        movementLabel.text = "Setup"
        setLabel.text = "Circuit 1/\(workout!.circuits.count) Set 1/\(workout!.circuits[0].numSets)"
        ui {
            self.gifView.animateWithImageData(UIImageJPEGRepresentation(self.currentCircuit!.setup.image!, 1.0)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipTextView.editable = true
        tipTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        tipTextView.editable = false
        tipTextView.alpha = 0
        tipTextView.textAlignment = .Center
        
        movementLabel.numberOfLines = 0
        movementLabel.sizeToFit()
        
        var image = UIImage(named: "fast_forward")?.imageWithRenderingMode(.AlwaysTemplate)
        nextButton.setImage(image, forState: .Normal)
        nextButton.tintColor = UIColor.somasoleColor()
        image = UIImage(named: "rewind")?.imageWithRenderingMode(.AlwaysTemplate)
        previousButton.setImage(image, forState: .Normal)
        previousButton.tintColor = UIColor.somasoleColor()
        image = UIImage(named: "info")?.imageWithRenderingMode(.AlwaysTemplate)
        infoButton.setImage(image, forState: .Normal)
        infoButton.tintColor = UIColor.somasoleColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        beginWorkout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tipTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! FinishedWorkoutViewController
        destVC.workout = workout
    }

}
