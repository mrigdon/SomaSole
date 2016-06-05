//
//  WorkoutsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class WorkoutsViewController: SegmentedPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // segmented strip
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let allWorkoutsVC = storyboard.instantiateViewControllerWithIdentifier("AllWorkoutsViewController")
//        let myWorkoutsVC = storyboard.instantiateViewControllerWithIdentifier("MyWorkoutsViewController")
        
//        return [allVideosVC, myVideosVC]
        return [allWorkoutsVC]
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
