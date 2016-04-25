//
//  FilterViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/19/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var addFilterClosure: ((filter: String, adding: Bool) -> Void)?
    var selectedFilters: [String]!

    @IBOutlet weak var upperBodyPill: PillButton!
    @IBOutlet weak var lowerBodyPill: PillButton!
    @IBOutlet weak var corePill: PillButton!
    @IBOutlet weak var totalBodyPill: PillButton!
    @IBOutlet weak var sportsSpecificPill: PillButton!
    @IBOutlet weak var challengesPill: PillButton!
    
    @IBAction func tappedFilterButton(sender: AnyObject) {
        let filterButton = sender as! PillButton
        
        let adding = !filterButton.selectedByUser
        
        addFilterClosure!(filter: (filterButton.titleLabel?.text)!, adding: adding)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // customize nav bar
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // associate filter titles with their pill
        let filterPillDict = [
            "Upper Body": upperBodyPill,
            "Lower Body": lowerBodyPill,
            "Core": corePill,
            "Total Body": totalBodyPill,
            "Sports Specific": sportsSpecificPill,
            "Challenges": challengesPill
        ]
        
        // set selected pills
        for filter in self.selectedFilters {
            let selectedPill = filterPillDict[filter]
            selectedPill!.setSelected()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
