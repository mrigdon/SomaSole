//
//  BasicsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/11/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BasicsViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    func stringFromHeight(height: Float) -> String {
        let heightFeet: Int = Int(floor(height))
        let heightInches: Int = Int((height-Float(heightFeet))*12.0)
        
        return "\(heightFeet)' \(heightInches)\""
    }
    
    func stringFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.stringFromDate(date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set label text
        let user = User.sharedModel
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        heightLabel.text = stringFromHeight(user.height!)
        weightLabel.text = "\(Int(user.weight!)) lbs"
        genderLabel.text = user.male == true ? "Male" : "Female"
        dateOfBirthLabel.text = stringFromDate(user.dateOfBirth!)
        profileImageView.image = user.profileImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Basic"
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
