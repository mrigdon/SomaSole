//
//  WorkoutsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/12/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyEmbeddedViewController: UITableViewController, IndicatorInfoProvider {
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "My Child title")
    }
}

class WorkoutsViewController: ButtonBarPagerTabStripViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    let whiteColor = UIColor.whiteColor()
    let lightBlueColor: UIColor = UIColor(red: 0.568627451, green: 0.7333333333, blue: 0.968627451, alpha: 1.0)
    var searchController: UISearchController!

    override func viewDidLoad() {
        // button bar customization
        settings.style.buttonBarHeight = 40
        settings.style.buttonBarBackgroundColor = whiteColor
        settings.style.buttonBarItemBackgroundColor = whiteColor
        settings.style.selectedBarBackgroundColor = lightBlueColor
        settings.style.buttonBarItemTitleColor = lightBlueColor
        settings.style.buttonBarMinimumLineSpacing = 0.0
        settings.style.buttonBarItemFont = UIFont.systemFontOfSize(14)
        
        super.viewDidLoad()
        
        // add search bar to nav bar
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        (UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self])).tintColor = UIColor.whiteColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("here")
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        return [MyEmbeddedViewController(), MyEmbeddedViewController(), MyEmbeddedViewController()]
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
