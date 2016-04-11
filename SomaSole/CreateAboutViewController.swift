//
//  CreateAboutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class CreateAboutViewController: UIViewController {
    
    var selectedActivities: [Activity] = []
    var selectedGoals: [Goal] = []

    // activity pills
    @IBOutlet weak var climbingPill: PillButton!
    @IBOutlet weak var basketballPill: PillButton!
    @IBOutlet weak var footballPill: PillButton!
    @IBOutlet weak var skiingPill: PillButton!
    @IBOutlet weak var baseballPill: PillButton!
    @IBOutlet weak var tennisPill: PillButton!
    @IBOutlet weak var soccerPill: PillButton!
    @IBOutlet weak var hockeyPill: PillButton!
    @IBOutlet weak var surfingPill: PillButton!
    @IBOutlet weak var yogaPill: PillButton!
    @IBOutlet weak var cyclingPill: PillButton!
    @IBOutlet weak var swimmingPill: PillButton!
    @IBOutlet weak var golfPill: PillButton!
    @IBOutlet weak var mmaPill: PillButton!
    @IBOutlet weak var rowingPill: PillButton!
    @IBOutlet weak var boxingPill: PillButton!
    @IBOutlet weak var trackPill: PillButton!
    @IBOutlet weak var otherPill: PillButton!
    
    // goal pills
    @IBOutlet weak var flexibilityPill: PillButton!
    @IBOutlet weak var functionalityPill: PillButton!
    @IBOutlet weak var strengthPill: PillButton!
    @IBOutlet weak var powerPill: PillButton!
    @IBOutlet weak var toningPill: PillButton!
    @IBOutlet weak var weightLossPill: PillButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set activity pills
        climbingPill.activity = .Climbing
        basketballPill.activity = .Basketball
        footballPill.activity = .Football
        skiingPill.activity = .Skiing
        baseballPill.activity = .Baseball
        tennisPill.activity = .Tennis
        soccerPill.activity = .Soccer
        hockeyPill.activity = .Hockey
        surfingPill.activity = .Surfing
        yogaPill.activity = .Yoga
        cyclingPill.activity = .Cycling
        swimmingPill.activity = .Swimming
        golfPill.activity = .Golf
        mmaPill.activity = .MMA
        rowingPill.activity = .Rowing
        boxingPill.activity = .Boxing
        trackPill.activity = .Track
        otherPill.activity = .Other
        
        // set goal pills
        flexibilityPill.goal = .Flexibility
        functionalityPill.goal = .Functionality
        strengthPill.goal = .Strength
        powerPill.goal = .Power
        toningPill.goal = .Toning
        weightLossPill.goal = .WeightLoss
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedFinish(sender: AnyObject) {
        // get all selected activities
        if climbingPill.selectedByUser { selectedActivities.append(climbingPill.activity!) }
        if basketballPill.selectedByUser { selectedActivities.append(basketballPill.activity!) }
        if footballPill.selectedByUser { selectedActivities.append(footballPill.activity!) }
        if skiingPill.selectedByUser { selectedActivities.append(skiingPill.activity!) }
        if baseballPill.selectedByUser { selectedActivities.append(baseballPill.activity!) }
        if tennisPill.selectedByUser { selectedActivities.append(tennisPill.activity!) }
        if soccerPill.selectedByUser { selectedActivities.append(soccerPill.activity!) }
        if hockeyPill.selectedByUser { selectedActivities.append(hockeyPill.activity!) }
        if surfingPill.selectedByUser { selectedActivities.append(surfingPill.activity!) }
        if yogaPill.selectedByUser { selectedActivities.append(yogaPill.activity!) }
        if cyclingPill.selectedByUser { selectedActivities.append(cyclingPill.activity!) }
        if swimmingPill.selectedByUser { selectedActivities.append(swimmingPill.activity!) }
        if golfPill.selectedByUser { selectedActivities.append(golfPill.activity!) }
        if mmaPill.selectedByUser { selectedActivities.append(mmaPill.activity!) }
        if rowingPill.selectedByUser { selectedActivities.append(rowingPill.activity!) }
        if boxingPill.selectedByUser { selectedActivities.append(boxingPill.activity!) }
        if trackPill.selectedByUser { selectedActivities.append(trackPill.activity!) }
        if otherPill.selectedByUser { selectedActivities.append(otherPill.activity!) }
        
        // get selected goals
        if flexibilityPill.selectedByUser { selectedGoals.append(flexibilityPill.goal!) }
        if functionalityPill.selectedByUser { selectedGoals.append(functionalityPill.goal!) }
        if strengthPill.selectedByUser { selectedGoals.append(strengthPill.goal!) }
        if powerPill.selectedByUser { selectedGoals.append(powerPill.goal!) }
        if toningPill.selectedByUser { selectedGoals.append(toningPill.goal!) }
        if weightLossPill.selectedByUser { selectedGoals.append(weightLossPill.goal!) }
        
        // set to user
        let user = User.sharedModel
        user.activities = selectedActivities
        user.goals = selectedGoals
        
        print("\(user.firstName) \(user.lastName) \(user.activities) \(user.goals)")
    }
    
    @IBAction func selectedPill(sender: AnyObject) {
        
    }

    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    */

}
