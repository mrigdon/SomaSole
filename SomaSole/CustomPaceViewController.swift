//
//  CustomPaceViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/6/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import MZTimerLabel
//import FLAnimatedImage
//import SwiftyMarkdown

class CustomPaceViewController: UIViewController {

    // variables
    var workout: Workout?
    var gifVisible = true
//    var timer = MZTimerLabel()
    var currentCircuit: Circuit?
    var movementCounter = 0
    var setCounter = 0
    var circuitCounter = 0
    
    // outlets
    @IBOutlet weak var movementLabel: UILabel!
//    @IBOutlet weak var gifView: FLAnimatedImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var tipTextView: UITextView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // actions
    @IBAction func tappedX(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: { [unowned self] in
//            self.gifView.stopAnimating()
//            self.timer.pause()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func tappedInfo(_ sender: AnyObject) {
//        gifView.alpha = gifVisible ? 0 : 1
        tipTextView.alpha = gifVisible ? 1 : 0
        gifVisible = !gifVisible
    }
    
    @IBAction func tappedPrevious(_ sender: AnyObject) {
        previous()
    }
    
    @IBAction func tappedNext(_ sender: AnyObject) {
        next()
    }
    
    // methods
    fileprivate func ui (_ task: @escaping () -> Void) {
        DispatchQueue.main.async(execute: {
            task()
        })
    }
    
    fileprivate func beginWorkout() {
        currentCircuit = workout?.circuits[0]
        movementLabel.text = "Setup"
        
//        let mdText = SwiftyMarkdown(string: "**Circuit:** \(circuitCounter+1)/\(workout!.circuits.count)   **Set:** \(setCounter+1)/\(currentCircuit!.sets)   **Movement:** \(movementCounter)/\(currentCircuit!.movements.count)")
//        setLabel.attributedText = mdText.attributedString()
        
        ui {
//            self.gifView.image = UIImage(data: UIImageJPEGRepresentation(self.currentCircuit!.setup.image, 1.0)!)
        }
    }
    
    fileprivate func next() {
        movementCounter += 1
        if movementCounter == currentCircuit!.movements.count + 1 { // +1 for the setup
            setCounter += 1
            if setCounter == currentCircuit!.sets {
                circuitCounter += 1
                setCounter = 0
            }
            movementCounter = 0
        }
        
        if circuitCounter == workout!.circuits.count {
            // done with workout
            performSegue(withIdentifier: "finishedSegue", sender: self)
            return
        }
        
        currentCircuit = workout?.circuits[circuitCounter]
        let movement: Movement? = movementCounter == 0 ? nil : currentCircuit!.movements[movementCounter - 1] // -1 for the setup
        movementLabel.text = movementCounter == 0 ? (setCounter == 0 ? "Setup" : "Rest") : movement!.title
        
//        let mdText = SwiftyMarkdown(string: "**Circuit:** \(circuitCounter+1)/\(workout!.circuits.count)   **Set:** \(setCounter+1)/\(currentCircuit!.sets)   **Movement:** \(movementCounter)/\(currentCircuit!.movements.count)")
//        setLabel.attributedText = mdText.attributedString()
        
        let imageData = movementCounter == 0 ? (setCounter == 0 ? UIImageJPEGRepresentation(currentCircuit!.setup.image, 1.0) : (try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Rest.gif", ofType: nil)!)))) : movement!.gif
        if movementCounter == 0 {
            ui {
//                self.gifView.image = UIImage(data: imageData!)
            }
        } else {
            ui {
//                self.gifView.animatedImage = FLAnimatedImage(animatedGIFData: imageData!)
            }
        }
        tipTextView.text = movementCounter == 0 ? "" : movement!.deskription
    }
    
    fileprivate func previous() {
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
        
//        let mdText = SwiftyMarkdown(string: "**Circuit:** \(circuitCounter+1)/\(workout!.circuits.count)   **Set:** \(setCounter+1)/\(currentCircuit!.sets)   **Movement:** \(movementCounter)/\(currentCircuit!.movements.count)")
//        setLabel.attributedText = mdText.attributedString()
        
        let imageData = movementCounter == 0 ? (setCounter == 0 ? UIImageJPEGRepresentation(currentCircuit!.setup.image, 1.0) : (try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Rest.gif", ofType: nil)!)))) : movement!.gif
        if movementCounter == 0 {
            ui {
//                self.gifView.image = UIImage(data: imageData!)
            }
        } else {
            ui {
//                self.gifView.animatedImage = FLAnimatedImage(animatedGIFData: imageData!)
            }
        }
        tipTextView.text = movementCounter == 0 ? "" : movement!.deskription
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipTextView.isEditable = true
        tipTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        tipTextView.isEditable = false
        tipTextView.isSelectable = false
        tipTextView.alpha = 0
        tipTextView.textAlignment = .center
        
        var image = UIImage(named: "fast_forward")?.withRenderingMode(.alwaysTemplate)
        nextButton.setImage(image, for: UIControlState())
        nextButton.tintColor = UIColor.somasoleColor()
        image = UIImage(named: "rewind")?.withRenderingMode(.alwaysTemplate)
        previousButton.setImage(image, for: UIControlState())
        previousButton.tintColor = UIColor.somasoleColor()
        image = UIImage(named: "info")?.withRenderingMode(.alwaysTemplate)
        infoButton.setImage(image, for: UIControlState())
        infoButton.tintColor = UIColor.somasoleColor()
        
        movementLabel.adjustsFontSizeToFitWidth = true
        setLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beginWorkout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tipTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! FinishedWorkoutViewController
        destVC.workout = workout
    }

}
