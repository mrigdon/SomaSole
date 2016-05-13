//
//  InWorkoutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/2/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class InWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // constants
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    // variables
    var workout: Workout?
    var labels: [String] = []
    var detailLabels: [String?] = []
    var movements = [Movement?]()
    var animationCells = [MovementCell]()

    // outlets
    @IBOutlet weak var movementImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    
    // methods
//    private func beginWorkout(index: Int) {
//        animationCells[index].layoutIfNeeded()
//        animationCells[index].progressViewWidth.constant = self.screenWidth
//        UIView.animateWithDuration(Double(animationCells[index].movement!.time), animations: {
//                self.animationCells[index].layoutIfNeeded()
//            }, completion: { finished in
//                let indexPath = NSIndexPath(forItem: index+1, inSection: 0)
//                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
//                self.beginWorkout(index+1)
//            }
//        )
//    }
    
    private func tableViewScrollTop(index: Int) {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    private func beginMovementInSet(circuitIndex: Int, setIndex: Int, workoutIndex: Int, completedSet: () -> (Void)) {
        // return if done with set in circuit
        if workoutIndex == 2 /*workout!.circuits[circuitIndex].movements.count*/ {
            completedSet()
            return
        }
        
        // animate blue progress
        animationCells[workoutIndex].layoutIfNeeded()
        animationCells[workoutIndex].progressViewWidth.constant = self.screenWidth
        UIView.animateWithDuration(Double(animationCells[workoutIndex].movement!.time), animations: {
            self.animationCells[workoutIndex].layoutIfNeeded()
            }, completion: { finished in
                self.animationCells[workoutIndex].resetBackground()
                self.tableViewScrollTop(workoutIndex+1)
                self.beginMovementInSet(circuitIndex, setIndex: setIndex, workoutIndex: workoutIndex+1, completedSet: completedSet)
            }
        )
    }
    
    private func beginSetInCircuit(circuitIndex: Int, setIndex: Int, completedCircuit: () -> Void) {
        // return if done with all sets in circuit
        if setIndex == 2 /*workout!.circuits[circuitIndex].numSets*/ {
            completedCircuit()
            return
        }
        
        beginMovementInSet(circuitIndex, setIndex: setIndex, workoutIndex: 0, completedSet: {
            self.tableViewScrollTop(0)
            self.beginSetInCircuit(circuitIndex, setIndex: setIndex+1, completedCircuit: completedCircuit)
        })
    }
    
    private func beginCircuit(circuitIndex: Int) {
        // return if done with all circuits in workout
        if circuitIndex == 2 /*workout!.circuits.count*/ {
            return
        }
        
        beginSetInCircuit(circuitIndex, setIndex: 0, completedCircuit: {
            self.beginCircuit(circuitIndex+1)
        })
    }
    
    private func beginWorkout() {
        beginCircuit(0)
    }
    
    // actions
    @IBAction func tappedX(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedPlayPause(sender: AnyObject) {
        
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.scrollEnabled = false
        self.tableView.alwaysBounceVertical = false

        for (index, circuit) in self.workout!.circuits.enumerate() {
            labels.append("Circuit \(index+1)")
            detailLabels.append("Set 1/\(circuit.numSets)")
            movements.append(nil)
            for movement in circuit.movements {
                labels.append(movement.title)
                detailLabels.append("\(movement.time)s")
                movements.append(movement)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // uitableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.labels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movementCell", forIndexPath: indexPath) as! MovementCell
        cell.resetBackground()
        
        cell.nameLabel.text = self.labels[indexPath.row]
        cell.timeLabel.text = self.detailLabels[indexPath.row]
        if let movement = self.movements[indexPath.row] {
            cell.movement = movement
            self.animationCells.append(cell)
        }
        if indexPath.row == 1 {
//            self.beginWorkout(0)
            self.beginWorkout()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
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
