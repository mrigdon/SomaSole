//
//  PurchasesViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PurchasesViewController: UITableViewController, IndicatorInfoProvider {
    
    let subscriptions = [
        ("All Essential", 5.99),
        ("Scott Schratwieser", 5.99)
    ]
    let purchases = [
        ("Essential Boulder Shoulders", 0.99),
        ("Liz Letchford Dynamic Warm-Up", 1.99)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Purchases")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return subscriptions.count
        }
        else {
            return purchases.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseId: String = (indexPath.section == 0) ? "subscriptionCell" : "purchaseCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath)

        if indexPath.section == 0 {
            let (title, price) = subscriptions[indexPath.row]
            
            cell.textLabel!.text = title
            cell.detailTextLabel!.text = "$" + String(price) + "/month"
        }
        else {
            let (title, price) = purchases[indexPath.row]
            
            cell.textLabel!.text = title
            cell.detailTextLabel!.text = "$" + String(price) + "/month"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Subscriptions"
        }
        else {
            return "Purchases"
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
