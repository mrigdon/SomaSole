//
//  SettingsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class SettingsViewController: UITableViewController, IndicatorInfoProvider {
    
    var firebase: Firebase?
    
    let EMAIL_SETTING :Int = 0
    let PASSWORD_SETTING :Int = 1
    let PAYMENT_SETTING :Int = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // init firebase
        firebase = Firebase(url: "http://somasole.firebaseio.com")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SETTINGS")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            firebase?.unauth()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            presentViewController(loginViewController, animated: true, completion: nil)
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
        }
        else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = indexPath.section == 0 ? "cell" : "logout"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        if indexPath.section == 0 {
            if indexPath.row == EMAIL_SETTING {
                cell.textLabel!.text = "Change Email"
                cell.detailTextLabel!.text = "rigdonmr@gmail.com"
            }
            else if indexPath.row == PASSWORD_SETTING {
                cell.textLabel!.text = "Change Password"
                cell.detailTextLabel!.text = "XXXXXXXX"
            }
            else {
                cell.textLabel!.text = "Change Payment"
                cell.detailTextLabel!.text = "XXXX-XXXX-XXXX-6969"
            }
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // get index path
        let indexPath = self.tableView.indexPathForSelectedRow
        
        // Get the new view controller using segue.destinationViewController.
        let destVC: ChangeSettingViewController = segue.destinationViewController as! ChangeSettingViewController
        
        // Pass the selected setting to the new view controller.
        destVC.selectedSetting = indexPath!.row
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

}
