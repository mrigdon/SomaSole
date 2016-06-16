//
//  CreateAboutViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase

class CreateAboutViewController: UIViewController {
    
    let firebaseURL = "https://somasole.firebaseio.com"
    var firebase: Firebase?
    
    var alertController: UIAlertController?
    
    var selectedActivities: [Int] = []
    var selectedGoals: [Int] = []
    
    var successfullyCreatedFirebaseUser: Bool?
    var uid: String?

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
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func stringFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.stringFromDate(date)
    }
    
    func saveUserData() {
        let user = User.sharedModel
        
        var userData: Dictionary<String, AnyObject> = [
            "uid": user.uid!,
            "firstName": user.firstName!,
            "lastName": user.lastName!,
            "email": user.email!,
            "height": user.height!,
            "weight": user.weight!,
            "male": user.male!,
            "dateOfBirth": stringFromDate(user.dateOfBirth!),
            "activities": user.activities!,
            "goals": user.goals!,
            "profileImageString": user.profileImageString(),
            "favoriteWorkoutKeys": [Int](),
            "favoriteVideoKeys": [String](),
            "purchasedVideos": [String](),
            "premium": user.premium
        ]
        
        // save to Firebase
        firebase?.childByAppendingPath("users").childByAppendingPath(user.uid).setValue(userData)
        
        // save uid to nsuserdefaults
        userData["password"] = User.sharedModel.password
        NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "firebaseUID")
        NSUserDefaults.standardUserDefaults().setObject(userData, forKey: "userData")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        stopProgressHud()
        
        // present main application
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewControllerWithIdentifier("MainViewController")
        presentViewController(main, animated: true, completion: nil)
    }
    
    func createFirebaseUserAndLogin() {
        let user = User.sharedModel
        if user.facebookUser {
            self.saveUserData()
        }
        firebase?.createUser(user.email, password: user.password, withValueCompletionBlock: { error, result in
            if error != nil {
                self.stopProgressHud()
                self.errorAlert("Something went wrong, please try again")
                self.successfullyCreatedFirebaseUser = false
            }
            else {
                User.sharedModel.uid = result["uid"] as? String
                self.saveUserData()
            }
        })
    }
    
    func errorAlert(message: String) {
        alertController!.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
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
        
        // init firebase
        firebase = Firebase(url: firebaseURL)
        
        // init alert controller
        alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController!.addAction(okayAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedFinish(sender: AnyObject) {
        // start progress hud
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // get all selected activities
        if climbingPill.selectedByUser { selectedActivities.append(climbingPill.activity!.hashValue) }
        if basketballPill.selectedByUser { selectedActivities.append(basketballPill.activity!.hashValue) }
        if footballPill.selectedByUser { selectedActivities.append(footballPill.activity!.hashValue) }
        if skiingPill.selectedByUser { selectedActivities.append(skiingPill.activity!.hashValue) }
        if baseballPill.selectedByUser { selectedActivities.append(baseballPill.activity!.hashValue) }
        if tennisPill.selectedByUser { selectedActivities.append(tennisPill.activity!.hashValue) }
        if soccerPill.selectedByUser { selectedActivities.append(soccerPill.activity!.hashValue) }
        if hockeyPill.selectedByUser { selectedActivities.append(hockeyPill.activity!.hashValue) }
        if surfingPill.selectedByUser { selectedActivities.append(surfingPill.activity!.hashValue) }
        if yogaPill.selectedByUser { selectedActivities.append(yogaPill.activity!.hashValue) }
        if cyclingPill.selectedByUser { selectedActivities.append(cyclingPill.activity!.hashValue) }
        if swimmingPill.selectedByUser { selectedActivities.append(swimmingPill.activity!.hashValue) }
        if golfPill.selectedByUser { selectedActivities.append(golfPill.activity!.hashValue) }
        if mmaPill.selectedByUser { selectedActivities.append(mmaPill.activity!.hashValue) }
        if rowingPill.selectedByUser { selectedActivities.append(rowingPill.activity!.hashValue) }
        if boxingPill.selectedByUser { selectedActivities.append(boxingPill.activity!.hashValue) }
        if trackPill.selectedByUser { selectedActivities.append(trackPill.activity!.hashValue) }
        if otherPill.selectedByUser { selectedActivities.append(otherPill.activity!.hashValue) }
        
        // get selected goals
        if flexibilityPill.selectedByUser { selectedGoals.append(flexibilityPill.goal!.hashValue) }
        if functionalityPill.selectedByUser { selectedGoals.append(functionalityPill.goal!.hashValue) }
        if strengthPill.selectedByUser { selectedGoals.append(strengthPill.goal!.hashValue) }
        if powerPill.selectedByUser { selectedGoals.append(powerPill.goal!.hashValue) }
        if toningPill.selectedByUser { selectedGoals.append(toningPill.goal!.hashValue) }
        if weightLossPill.selectedByUser { selectedGoals.append(weightLossPill.goal!.hashValue) }
        
        // set to user
        let user = User.sharedModel
        user.activities = selectedActivities
        user.goals = selectedGoals
        
        // create firebase user
        createFirebaseUserAndLogin()
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
