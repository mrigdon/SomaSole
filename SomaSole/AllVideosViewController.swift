//
//  AllVideosViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/28/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Firebase
import XLPagerTabStrip
import Masonry

class AllVideosViewController: UITableViewController, IndicatorInfoProvider, UISearchBarDelegate {
    
    // constants
    let searchBar = UISearchBar()
    
    // variables
    var videos = [Video]()
    var filteredVideos = [Video]()
    
    // methods
    @objc private func tappedOverlay() {
        performSegueWithIdentifier("paymentSegue", sender: self)
    }
    
    private func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    private func loadPublic() {
        FirebaseManager.sharedRootRef.childByAppendingPath("videos").childByAppendingPath("public").observeEventType(.ChildAdded, withBlock: { snapshot in
            let video = Video(id: snapshot.key, title: snapshot.value as! String)
            self.videos.insert(video, atIndex: 0)
            self.reloadTableView()
        })
    }
    
    private func loadPrivate() {
        for key in User.sharedModel.purchasedVideoKeys {
            FirebaseManager.sharedRootRef.childByAppendingPath("videos").childByAppendingPath("private").childByAppendingPath(key).observeEventType(.Value, withBlock: { snapshot in
                let video = Video(id: snapshot.key, title: snapshot.value as! String)
                self.videos.insert(video, atIndex: 0)
                self.reloadTableView()
            })
        }
    }
    
    private func filterContentForSearchText(searchText: String) {
        filteredVideos = videos.filter { video in
            return video.title.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        reloadTableView()
    }
    
    // delegates
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "All Videos"
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.tintColor = UIColor.blackColor()
        searchBar.layer.borderWidth = 0.0
        searchBar.layer.borderColor = UIColor.whiteColor().CGColor
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .Done
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 274
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        loadPublic()
        loadPrivate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isFirstResponder() && searchBar.text != "" {
            return filteredVideos.count
        }
        
        return videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as! VideoCell

        let video = searchBar.isFirstResponder() && searchBar.text != "" ? filteredVideos[indexPath.row] : videos[indexPath.row]
        cell.titleLabel.text = video.title
        cell.playerView.loadWithVideoId(video.id)
        cell.setPurchaseOverlay(indexPath.row > 2 && !User.sharedModel.premium)
        if cell.purchaseOverlayAdded {
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(tappedOverlay))
            cell.overlayView.addGestureRecognizer(tap1)
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(tappedOverlay))
            cell.circleView.addGestureRecognizer(tap2)
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row <= 2 || User.sharedModel.premium
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
