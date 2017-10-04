//
//  FilterViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/19/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var addFilterClosure: ((_ filter: WorkoutTag, _ adding: Bool) -> Void)?
    var selectedFilters = [WorkoutTag]()

    @IBOutlet weak var upperBodyPill: PillButton!
    @IBOutlet weak var lowerBodyPill: PillButton!
    @IBOutlet weak var corePill: PillButton!
    @IBOutlet weak var totalBodyPill: PillButton!
    
    @IBAction func tappedFilterButton(_ sender: AnyObject) {
        let filterButton = sender as! PillButton
        
        let adding = !filterButton.selectedByUser
        
        addFilterClosure!(filterButton.workoutTag!, adding)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize nav bar
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        // set workout tag for each pill
        upperBodyPill.workoutTag = .upperBody
        lowerBodyPill.workoutTag = .lowerBody
        corePill.workoutTag = .core
        totalBodyPill.workoutTag = .totalBody
        
        // associate filter titles with their pill
        let filterPillDict = [
            WorkoutTag.upperBody: upperBodyPill,
            WorkoutTag.lowerBody: lowerBodyPill,
            WorkoutTag.core: corePill,
            WorkoutTag.totalBody: totalBodyPill,
        ]
        
        // set selected pills
        for filter in self.selectedFilters {
            let selectedPill = filterPillDict[filter]
            selectedPill!?.setSelected()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
