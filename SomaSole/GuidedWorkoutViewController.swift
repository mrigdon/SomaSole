//
//  GuidedWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import KDCircularProgress
import FLAnimatedImage
import MZTimerLabel
import SwiftyMarkdown

extension UIColor {
    static func progressGrayColor() -> UIColor {
        return UIColor(red: 220/255, green: 222/255, blue: 224/255, alpha: 1.0)
    }
    
    static func somasoleColor() -> UIColor { return UIColor(red: 65/255, green: 182/255, blue: 230/255, alpha: 1.0) }
}

extension KDCircularProgress {
    func running() {
        clockwise = true
        trackColor = UIColor.progressGrayColor()
        angle = 0
        setColors(UIColor.somasoleColor(), UIColor.somasoleColor(), UIColor.somasoleColor())
    }
    
    func loading() {
        clockwise = false
        setColors(UIColor.progressGrayColor(), UIColor.progressGrayColor(), UIColor.progressGrayColor())
        trackColor = UIColor.clearColor()
        angle = 0
    }
}

class GuidedWorkoutViewController: UIViewController {
    
    private let setupTime: Double = 15
    
    // variables
    var workout: Workout?
    var gifVisible = true
    var playButton = UIBarButtonItem()
    var pauseButton = UIBarButtonItem()
    var timer = MZTimerLabel()
    
    private var movementCounter = 0
    private var setCounter = 0
    private var circuitCounter = 0
    private var currentCircuit: Circuit?

    // outlets
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var gifView: FLAnimatedImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var timeLabel: MZTimerLabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var tipTextView: UITextView!
    
    // actions
    @IBAction func tappedX(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] in
            self.gifView.stopAnimating()
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
    
    @IBAction func swipedRight(sender: AnyObject) {
        
    }
    
    @IBAction func swipedLeft(sender: AnyObject) {
        
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
        
        let mdText = SwiftyMarkdown(string: "**Circuit:** \(circuitCounter+1)/\(workout!.circuits.count)   **Set:** \(setCounter+1)/\(currentCircuit!.sets)   **Movement:** \(movementCounter)/\(currentCircuit!.movements.count)")
        setLabel.attributedText = mdText.attributedString()
        
        ui {
            self.gifView.image = UIImage(data: UIImageJPEGRepresentation(self.currentCircuit!.setup.image, 1.0)!)
        }
        
        timer = MZTimerLabel(label: timeLabel, andTimerType: MZTimerLabelTypeTimer)
        timer.setCountDownTime(Double(workout!.time))
        timer.timeFormat = "mm:ss"
        timer.start()
        
        startMovement()
    }
    
    private func startMovement(time: Double? = nil) {
        ui {
            self.progressView.animateToAngle(360, duration: 3, completion: { finished in
                self.progressView.running()
                self.ui {
                    self.progressView.animateToAngle(360, duration: time ?? 15, completion: { finished in
                        self.progressView.loading()
                        SoundManager.sharedManager.playSound(named: "bells")
                        self.next()
                    })
                }
            })
        }
    }
    
    @objc private func play() {
        let pausedTime = progressView.layer.timeOffset
        progressView.layer.speed = 1.0
        progressView.layer.timeOffset = 0.0
        progressView.layer.beginTime = 0.0
        let timeSincePause = progressView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        progressView.layer.beginTime = timeSincePause
        gifView.startAnimating()
        timer.start()
        navigationItem.rightBarButtonItem = pauseButton
    }
    
    @objc private func pause() {
        let pausedTime = progressView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        progressView.layer.speed = 0
        progressView.layer.timeOffset = pausedTime
        gifView.stopAnimating()
        timer.pause()
        navigationItem.rightBarButtonItem = playButton
    }
    
    private func next() {
        // 1. update counters
        movementCounter += 1
        if movementCounter == currentCircuit!.movements.count + 1 { // +1 for the setup
            setCounter += 1
            if setCounter == currentCircuit!.sets {
                circuitCounter += 1
                setCounter = 0
            }
            movementCounter = 0
        }
        
        // 2. check if finished
        if circuitCounter == workout!.circuits.count {
            // done with workout
            performSegueWithIdentifier("finishedSegue", sender: self)
            return
        }
        
        // 3. get current circuit and set movement label
        currentCircuit = workout?.circuits[circuitCounter]
        let movement: Movement? = movementCounter == 0 ? nil : currentCircuit!.movements[movementCounter - 1] // -1 for the setup
        movementLabel.text = movementCounter == 0 ? (setCounter == 0 ? "Setup" : "Rest") : movement!.title
        
        // 4. set set label
        let mdText = SwiftyMarkdown(string: "**Circuit:** \(circuitCounter+1)/\(workout!.circuits.count)   **Set:** \(setCounter+1)/\(currentCircuit!.sets)   **Movement:** \(movementCounter)/\(currentCircuit!.movements.count)")
        setLabel.attributedText = mdText.attributedString()
        
        // 5. start gifView and set tip label
        let imageData = movementCounter == 0 ? (setCounter == 0 ? UIImageJPEGRepresentation(currentCircuit!.setup.image, 1.0) : NSData(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Rest.gif", ofType: nil)!))) : movement!.gif
        if movementCounter == 0 {
            ui {
                self.gifView.image = UIImage(data: imageData!)
            }
        } else {
            ui {
                self.gifView.animatedImage = FLAnimatedImage(animatedGIFData: imageData!)
            }
        }
        tipTextView.text = movementCounter == 0 ? "" : movement!.deskription
        
        // 6. start movement
        startMovement(movementCounter == 0 ? nil : Double(movement!.time))
    }
    
    private func previous() {
        if circuitCounter == 0 && setCounter == 0 && movementCounter == 0 {
            return
        }
        
        movementCounter -= 1
        if movementCounter == -1 {
            setCounter -= 1
            if setCounter == -1 {
                circuitCounter -= 1
                setCounter = workout!.circuits[circuitCounter].sets - 1
            }
            movementCounter = workout!.circuits[circuitCounter].movements.count
        }
        
        currentCircuit = workout?.circuits[circuitCounter]
        let movement: Movement? = movementCounter == 0 ? nil : currentCircuit!.movements[movementCounter - 1]
        movementLabel.text = movementCounter == 0 ? (setCounter == 0 ? "Setup" : "Rest") : movement!.title
        
        let mdText = SwiftyMarkdown(string: "**Circuit:** \(circuitCounter+1)/\(workout!.circuits.count)   **Set:** \(setCounter+1)/\(currentCircuit!.sets)   **Movement:** \(movementCounter)/\(currentCircuit!.movements.count)")
        setLabel.attributedText = mdText.attributedString()
        
        let imageData = movementCounter == 0 ? (setCounter == 0 ? UIImageJPEGRepresentation(currentCircuit!.setup.image, 1.0) : NSData(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Rest.gif", ofType: nil)!))) : movement!.gif
        if movementCounter == 0 {
            ui {
                self.gifView.image = UIImage(data: imageData!)
            }
        } else {
            ui {
                self.gifView.animatedImage = FLAnimatedImage(animatedGIFData: imageData!)
            }
        }
        tipTextView.text = movementCounter == 0 ? "" : movement!.deskription
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseButton = UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: #selector(pause))
        playButton = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: #selector(play))
        navigationItem.rightBarButtonItem = pauseButton
        
        tipTextView.editable = true
        tipTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        tipTextView.editable = false
        tipTextView.selectable = false
        tipTextView.alpha = 0
        tipTextView.textAlignment = .Center
        
        movementLabel.adjustsFontSizeToFitWidth = true
        setLabel.adjustsFontSizeToFitWidth = true
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
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! FinishedWorkoutViewController
        destVC.workout = workout
    }

}
