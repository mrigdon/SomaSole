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

class ProfileViewController: ButtonBarPagerTabStripViewController/*, UINavigationBarDelegate*/ {
    
    let lightBlueColor: UIColor = UIColor(red: 0.568627451, green: 0.7333333333, blue: 0.968627451, alpha: 1.0)
    let whiteColor = UIColor.whiteColor()
    var firebase: Firebase?
    
    override func viewDidLoad() {
        // nav bar customization
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // button bar customization
        settings.style.buttonBarBackgroundColor = whiteColor
        settings.style.buttonBarItemBackgroundColor = whiteColor
        settings.style.selectedBarBackgroundColor = lightBlueColor
        settings.style.buttonBarItemTitleColor = UIColor.somasoleColor()
        settings.style.buttonBarMinimumLineSpacing = 0.0
        settings.style.buttonBarItemFont = UIFont.systemFontOfSize(14)
        settings.style.selectedBarHeight = 3
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // init firebase
        firebase = Firebase(url: "https://somasole.firebaseio.com")
        
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

