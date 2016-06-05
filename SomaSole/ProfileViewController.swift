//
//  ProfileViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/4/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class ProfileViewController: SegmentedPagerTabStripViewController {
    
    override func viewDidLoad() {
        // nav bar customization
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let basicsViewController = storyboard.instantiateViewControllerWithIdentifier("BasicsViewController")
        let purchasesViewController = storyboard.instantiateViewControllerWithIdentifier("PurchasesViewController")
        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController")
        
        return [basicsViewController, purchasesViewController, settingsViewController]
    }

}

