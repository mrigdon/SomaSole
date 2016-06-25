//
//  InWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/2/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Gifu

extension Bool {
    var alpha: CGFloat {
        return self ? 1 : 0
    }
}

class InWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // constants
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    // variables
    var workout: Workout?
    var playing = true
    var currentIndexPath: NSIndexPath?
    var currentCell: MovementCell?
    var playButton: UIBarButtonItem?
    var pauseButton: UIBarButtonItem?
    var gifVisible = true
    var running = true
    var customPace = false
    var movementCounter = 0
    var setCounter = 0
    var circuitCounter = 0
    
    var currentCircuit: Circuit?
    
    // outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var movementImageView: AnimatableImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var setupImageView: UIImageView!
    
    // methods
    private func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    private func beginMovementInSet(circuitIndex: Int, setIndex: Int, workoutIndex: Int, completedSet: () -> (Void)) {
        // return if done with set in circuit
        if workoutIndex == workout!.circuits[circuitIndex].movements.count {
            completedSet()
            return
        }
        
        // get index path for cell and scroll to cell
        let indexPath = NSIndexPath(forRow: workoutIndex, inSection: circuitIndex)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        
        // animate image view and set tip text
        let movement = workout!.circuits[circuitIndex].movements[workoutIndex]
        dispatch_async(dispatch_get_main_queue(), {
            self.movementImageView.animateWithImageData(movement.gif!)
        })
        tipLabel.text = movement.movementDescription
        
        // animate blue progress
        currentIndexPath = indexPath
        currentCell = self.tableView.cellForRowAtIndexPath(indexPath) as? MovementCell
        currentCell!.layoutIfNeeded()
        currentCell!.progressViewWidth.constant = self.screenWidth
        UIView.animateWithDuration(Double(currentCell!.movement!.time!), animations: {
            self.currentCell!.layoutIfNeeded()
            }, completion: { finished in
                if self.running {
                    self.currentCell!.resetBackground()
                    self.beginMovementInSet(circuitIndex, setIndex: setIndex, workoutIndex: workoutIndex+1, completedSet: completedSet)
                }
            }
        )
    }
    
    private func beginSetInCircuit(circuitIndex: Int, setIndex: Int, completedCircuit: () -> Void) {
        // return if done with all sets in circuit
        if setIndex == workout!.circuits[circuitIndex].numSets {
            completedCircuit()
            return
        }
        
        beginMovementInSet(circuitIndex, setIndex: setIndex, workoutIndex: 0, completedSet: {
            let indexPath = NSIndexPath(forRow: 0, inSection: circuitIndex)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
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
        if customPace {
            // for custom pace workouts
            let firstCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! MovementCell
            currentCell = firstCell
            currentCircuit = workout?.circuits[0]
            firstCell.layoutIfNeeded()
            firstCell.setBackground()
            firstCell.layoutIfNeeded()
            let movement = currentCircuit!.movements[movementCounter]
            dispatch_async(dispatch_get_main_queue(), {
                self.movementImageView.animateWithImageData(movement.gif!)
            })
            tipLabel.text = movement.movementDescription
            
        } else {
            // for timed workouts
            beginCircuit(0, completedWorkout: {
                self.performSegueWithIdentifier("finishedSegue", sender: self)
            })
        }
    }
    
    @objc private func play() {
        let pausedTime = currentCell!.progressView.layer.timeOffset
        currentCell!.progressView.layer.speed = 1.0
        currentCell!.progressView.layer.timeOffset = 0.0
        currentCell!.progressView.layer.beginTime = 0.0
        let timeSincePause = currentCell!.progressView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        currentCell!.progressView.layer.beginTime = timeSincePause
        movementImageView.startAnimatingGIF()
        navigationBar.topItem!.rightBarButtonItem = pauseButton
    }
    
    @objc private func pause() {
        let pausedTime = currentCell!.progressView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        currentCell!.progressView.layer.speed = 0.0
        currentCell!.progressView.layer.timeOffset = pausedTime
        movementImageView.stopAnimatingGIF()
        navigationBar.topItem!.rightBarButtonItem = playButton
    }
    
    // actions
    @IBAction func tappedX(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] in
            self.running = false
            self.movementImageView.stopAnimatingGIF()
            self.currentCell?.progressView.layer.removeAllAnimations()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    @IBAction func tappedInfo(sender: AnyObject) {
        if gifVisible {
            movementImageView.layer.opacity = 0.0
            tipLabel.layer.opacity = 1.0
            gifVisible = false
        }
        else {
            movementImageView.layer.opacity = 1.0
            tipLabel.layer.opacity = 0.0
            gifVisible = true
        }
    }
    
    @IBAction func tappedNext(sender: AnyObject) {
        currentCell?.layoutIfNeeded()
        currentCell?.resetBackground()
        currentCell?.layoutIfNeeded()
        
        movementCounter += 1
        if movementCounter == currentCircuit!.movements.count {
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
        let indexPath = NSIndexPath(forRow: movementCounter, inSection: circuitCounter)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        currentCell = tableView.cellForRowAtIndexPath(indexPath) as? MovementCell
        tableView.layoutIfNeeded()
        currentCell?.setBackground()
        tableView.layoutIfNeeded()
        let movement = currentCircuit!.movements[movementCounter]
        dispatch_async(dispatch_get_main_queue(), {
            self.movementImageView.animateWithImageData(movement.gif!)
        })
        tipLabel.text = movement.movementDescription
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable scroll
        self.tableView.scrollEnabled = false
        self.tableView.alwaysBounceVertical = false
        
        // uibarbuttons
        pauseButton = UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: #selector(self.pause))
        playButton = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: #selector(self.play))
        navigationBar.topItem!.rightBarButtonItem = pauseButton
        
        // init tip view
        tipLabel.text = workout?.circuits[0].movements[0].movementDescription
        tipLabel.layer.opacity = 0.0
        
        // remove next button if not custom pace
        nextButton.enabled = customPace
        nextButton.alpha = customPace.alpha
    }
    
    override func viewDidAppear(animated: Bool) {
        beginWorkout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // uitableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return workout!.circuits.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout!.circuits[section].movements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movementCell", forIndexPath: indexPath) as! MovementCell
        
        let movement = self.workout!.circuits[indexPath.section].movements[indexPath.row]
        cell.nameLabel.text = movement.title
        cell.nameLabel.sizeToFit()
        cell.timeLabel.text = "\(movement.time!)s"
        cell.timeLabel.sizeToFit()
        cell.movement = movement
        
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let circuit = workout!.circuits[section]
        //        return "Circuit \(section+1) (Set \(circuit.currentSet)/\(circuit.numSets))"
        return "Circuit \(section+1) (\(circuit.numSets) Sets)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! FinishedWorkoutViewController
        destVC.workout = workout
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
