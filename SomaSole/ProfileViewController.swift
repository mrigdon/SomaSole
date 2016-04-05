//
//  ProfileViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/4/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyEmbeddedViewController: UITableViewController, IndicatorInfoProvider {
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "My Child title")
    }
}

class ProfileViewController: ButtonBarPagerTabStripViewController {
    
    let lightBlueColor: UIColor = UIColor(red: 0.568627451, green: 0.7333333333, blue: 0.968627451, alpha: 1.0)
    
    override func viewDidLoad() {
        // button bar customization
        settings.style.buttonBarBackgroundColor = lightBlueColor
        settings.style.buttonBarItemBackgroundColor = lightBlueColor
        settings.style.selectedBarBackgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        settings.style.buttonBarMinimumLineSpacing = 0.0
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let purchasesViewController = storyboard.instantiateViewControllerWithIdentifier("PurchasesViewController")
        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController")
        
        return [BasicViewController(), purchasesViewController, settingsViewController]
    }


}

