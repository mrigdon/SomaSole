//
//  GuidedWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import KDCircularProgress
import Gifu
import MZTimerLabel

extension UIColor {
    static func progressGrayColor() -> UIColor {
        return UIColor(red: 220/255, green: 222/255, blue: 224/255, alpha: 1.0)
    }
}

class GuidedWorkoutViewController: UIViewController {
    
    // variables
    var workout: Workout?
    var gifVisible = true
    var playButton = UIBarButtonItem()
    var pauseButton = UIBarButtonItem()
    var timer = MZTimerLabel()

    // outlets
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var gifView: AnimatableImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var timeLabel: MZTimerLabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var tipTextView: UITextView!
    
    // actions
    @IBAction func tappedX(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] in
            self.gifView.stopAnimatingGIF()
            self.progressView.pauseAnimation()
            self.timer.pause()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    @IBAction func tappedInfo(sender: AnyObject) {
        gifView.alpha = gifVisible ? 0 : 1
        tipTextView.alpha = gifVisible ? 1 : 0
        gifVisible = !gifVisible
    }
    
    // methods
    private func ui (task: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            task()
        })
    }
    
    private func beginMovementInSet(circuitIndex: Int, setIndex: Int, movementIndex: Int, completedSet: () -> (Void)) {
        // return if done with set in circuit
        if movementIndex == workout!.circuits[circuitIndex].movements.count + 1 { // +1 for the setup
            completedSet()
            return
        }
        
        // animate image view and set tip text
        let circuit = workout!.circuits[circuitIndex]
        let movement: Movement? = movementIndex == 0 ? nil : circuit.movements[movementIndex - 1] // -1 to account for setup
        let imageData = movementIndex == 0 ? (setIndex == 0 ? UIImageJPEGRepresentation(circuit.setup.image!, 1.0) : NSData(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Rest.gif", ofType: nil)!))) : movement!.gif
        dispatch_async(dispatch_get_main_queue(), {
            self.gifView.animateWithImageData(imageData!)
        })
        movementLabel.text = movementIndex == 0 ? (setIndex == 0 ? "Setup" : "Rest") : movement!.title
        tipTextView.text = movementIndex == 0 ? (circuit.setup.long ? "Long Length" : "Short Length") : movement!.movementDescription
        
        // animate blue progress
        ui {
            self.progressView.animateToAngle(360, duration: 3, completion: { finished in
                self.progressView.clockwise = true
                self.progressView.trackColor = UIColor.progressGrayColor()
                self.progressView.angle = 0
                self.progressView.setColors(UIColor.somasoleColor(), UIColor.somasoleColor(), UIColor.somasoleColor())
                let time = movementIndex == 0 ? 15 : Double(movement!.time!)
                self.ui {
                    self.progressView.animateToAngle(360, duration: time, completion: { finished in
                        self.progressView.clockwise = false
                        self.progressView.setColors(UIColor.progressGrayColor(), UIColor.progressGrayColor(), UIColor.progressGrayColor())
                        self.progressView.trackColor = UIColor.clearColor()
                        self.progressView.angle = 0
                        self.beginMovementInSet(circuitIndex, setIndex: setIndex, movementIndex: movementIndex + 1, completedSet: completedSet)
                    })
                }
            })
        }
    }
    
    private func beginSetInCircuit(circuitIndex: Int, setIndex: Int, completedCircuit: () -> Void) {
        // return if done with all sets in circuit
        if setIndex == workout!.circuits[circuitIndex].numSets {
            completedCircuit()
            return
        }
        
        setLabel.text = "Circuit \(circuitIndex+1)/\(workout!.circuits.count) Set \(setIndex+1)/\(workout!.circuits[circuitIndex].numSets)"
        
        beginMovementInSet(circuitIndex, setIndex: setIndex, movementIndex: 0, completedSet: {
            self.beginSetInCircuit(circuitIndex, setIndex: setIndex+1, completedCircuit: completedCircuit)
        })
    }
    
    private func beginCircuit(circuitIndex: Int, completedWorkout: () -> Void) {
        // return if done with all circuits in workout
        if circuitIndex == workout!.circuits.count {
            completedWorkout()
            return
        }
        
        beginSetInCircuit(circuitIndex, setIndex: 0, completedCircuit: {
            self.beginCircuit(circuitIndex+1, completedWorkout: completedWorkout)
        })
    }
    
    private func beginWorkout() {
        timer = MZTimerLabel(label: timeLabel, andTimerType: MZTimerLabelTypeTimer)
        timer.setCountDownTime(Double(workout!.time) * 60)
        timer.timeFormat = "mm:ss"
        timer.start()
        beginCircuit(0, completedWorkout: {
            self.performSegueWithIdentifier("finishedSegue", sender: self)
        })
    }
    
    @objc private func play() {
        let pausedTime = progressView.layer.timeOffset
        progressView.layer.speed = 1.0
        progressView.layer.timeOffset = 0.0
        progressView.layer.beginTime = 0.0
        let timeSincePause = progressView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        progressView.layer.beginTime = timeSincePause
        gifView.startAnimatingGIF()
        timer.start()
        navigationItem.rightBarButtonItem = pauseButton
    }
    
    @objc private func pause() {
        let pausedTime = progressView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        progressView.layer.speed = 0
        progressView.layer.timeOffset = pausedTime
        gifView.stopAnimatingGIF()
        timer.pause()
        navigationItem.rightBarButtonItem = playButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseButton = UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: #selector(pause))
        playButton = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: #selector(play))
        navigationItem.rightBarButtonItem = pauseButton
        
        tipTextView.editable = true
        tipTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        tipTextView.editable = false
        tipTextView.alpha = 0
        tipTextView.textAlignment = .Center
        
        movementLabel.numberOfLines = 0
        movementLabel.sizeToFit()
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
