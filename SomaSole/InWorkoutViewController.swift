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
    var movements = [(Movement, Int)?]()
    var animationCells = [MovementCell]()

    // outlets
    @IBOutlet weak var movementImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    
    // methods
    private func animateProgressView(cell: MovementCell) {
        cell.layoutIfNeeded()
        cell.progressViewWidth.constant = self.screenWidth
        UIView.animateWithDuration(Double(cell.movement!.1), animations: {
            cell.layoutIfNeeded()
        })
    }
    
    private func beginWorkout(index: Int) {
        animationCells[index].layoutIfNeeded()
        animationCells[index].progressViewWidth.constant = self.screenWidth
        UIView.animateWithDuration(Double(animationCells[index].movement!.1), animations: {
                self.animationCells[index].layoutIfNeeded()
            }, completion: { finished in
                self.beginWorkout(index+1)
            }
        )
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

        // Do any additional setup after loading the view.
        for (index, circuit) in self.workout!.circuits.enumerate() {
            labels.append("Circuit \(index+1)")
            detailLabels.append("Set 1/\(circuit.numSets)")
            movements.append(nil)
            for movement in circuit.movements {
                labels.append(movement.0.title)
                detailLabels.append("\(movement.1)s")
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
        
        cell.nameLabel.text = self.labels[indexPath.row]
        cell.timeLabel.text = self.detailLabels[indexPath.row]
        
        return cell
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
