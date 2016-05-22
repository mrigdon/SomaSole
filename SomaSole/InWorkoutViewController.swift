//
//  InWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/2/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Gifu
import pop

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

    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var movementImageView: AnimatableImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    
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
        
        // animate blue progress
        currentIndexPath = indexPath
        currentCell = (self.tableView.cellForRowAtIndexPath(indexPath) as! MovementCell)
        (self.tableView.cellForRowAtIndexPath(indexPath) as! MovementCell).layoutIfNeeded()
        (self.tableView.cellForRowAtIndexPath(indexPath) as! MovementCell).progressViewWidth.constant = self.screenWidth
        let movement = workout!.circuits[circuitIndex].movements[workoutIndex]
        movementImageView.animateWithImageData(movement.gif!)
        UIView.animateWithDuration(Double((self.tableView.cellForRowAtIndexPath(indexPath) as! MovementCell).movement!.time!), animations: {
            (self.tableView.cellForRowAtIndexPath(indexPath) as! MovementCell).layoutIfNeeded()
            }, completion: { finished in
                (self.tableView.cellForRowAtIndexPath(indexPath) as! MovementCell).resetBackground()
                self.beginMovementInSet(circuitIndex, setIndex: setIndex, workoutIndex: workoutIndex+1, completedSet: completedSet)
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
        beginCircuit(0, completedWorkout: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let finishedVC = storyboard.instantiateViewControllerWithIdentifier("FinishedWorkoutViewController") as! FinishedWorkoutViewController
            finishedVC.workout = self.workout
            self.presentViewController(finishedVC, animated: true, completion: nil)
        })
    }
    
    @objc private func play() {
        let pausedTime = (tableView.cellForRowAtIndexPath(currentIndexPath!) as! MovementCell).progressView.layer.timeOffset
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
        self.dismissViewControllerAnimated(true, completion: nil)
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
        cell.timeLabel.text = "\(movement.time)s"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
