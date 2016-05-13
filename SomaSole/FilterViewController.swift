//
//  FilterViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/19/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var addFilterClosure: ((filter: WorkoutTag, adding: Bool) -> Void)?
    var selectedFilters = [WorkoutTag]()

    @IBOutlet weak var upperBodyPill: PillButton!
    @IBOutlet weak var lowerBodyPill: PillButton!
    @IBOutlet weak var corePill: PillButton!
    @IBOutlet weak var totalBodyPill: PillButton!
    
    @IBAction func tappedFilterButton(sender: AnyObject) {
        let filterButton = sender as! PillButton
        
        let adding = !filterButton.selectedByUser
        
        addFilterClosure!(filter: filterButton.workoutTag!, adding: adding)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize nav bar
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // set workout tag for each pill
        upperBodyPill.workoutTag = .UpperBody
        lowerBodyPill.workoutTag = .LowerBody
        corePill.workoutTag = .Core
        totalBodyPill.workoutTag = .TotalBody
        
        // associate filter titles with their pill
        let filterPillDict = [
            WorkoutTag.UpperBody: upperBodyPill,
            WorkoutTag.LowerBody: lowerBodyPill,
            WorkoutTag.Core: corePill,
            WorkoutTag.TotalBody: totalBodyPill,
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
