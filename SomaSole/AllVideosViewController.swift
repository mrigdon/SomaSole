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
    var unfilledStarButton: UIBarButtonItem?
    var filledStarButton: UIBarButtonItem?
    var favorites = false
    
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
            if User.sharedModel.favoriteVideoKeys.contains(video.id) {
                User.sharedModel.favoriteVideos.append(video)
            }
            self.reloadTableView()
        })
    }
    
    private func loadPrivate() {
        for key in User.sharedModel.purchasedVideoKeys {
            FirebaseManager.sharedRootRef.childByAppendingPath("videos").childByAppendingPath("private").childByAppendingPath(key).observeEventType(.Value, withBlock: { snapshot in
                let video = Video(id: snapshot.key, title: snapshot.value as! String)
                self.videos.insert(video, atIndex: 0)
                if User.sharedModel.favoriteVideoKeys.contains(video.id) {
                    User.sharedModel.favoriteVideos.append(video)
                }
                self.reloadTableView()
            })
        }
    }
    
    private func filterContentForSearchText(searchText: String) {
        filteredVideos = (favorites ? User.sharedModel.favoriteVideos : videos).filter { video in
            return video.title.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        reloadTableView()
    }
    
    @objc private func tappedUnfilledStar() {
        // switch to favorites
        navigationItem.rightBarButtonItem = filledStarButton
        favorites = true
        reloadTableView()
    }
    
    @objc private func tappedFilledStar() {
        // switch to non-favorites
        navigationItem.rightBarButtonItem = unfilledStarButton
        favorites = false
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
        
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
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
        
        unfilledStarButton = UIBarButtonItem(image: UIImage(named: "star_unfilled"), style: .Plain, target: self, action: #selector(tappedUnfilledStar))
        unfilledStarButton?.tintColor = UIColor.goldColor()
        filledStarButton = UIBarButtonItem(image: UIImage(named: "star_filled"), style: .Plain, target: self, action: #selector(tappedFilledStar))
        filledStarButton?.tintColor = UIColor.goldColor()
        navigationItem.rightBarButtonItem = unfilledStarButton

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
        
        return favorites ? User.sharedModel.favoriteVideos.count : videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseID = indexPath.row > 2 && !User.sharedModel.premium ? "videoOverlayCell" : "videoCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID, forIndexPath: indexPath) 

        let video = searchBar.isFirstResponder() && searchBar.text != "" ? filteredVideos[indexPath.row] : (favorites ? User.sharedModel.favoriteVideos[indexPath.row] : videos[indexPath.row])
        
        if indexPath.row > 2 && !User.sharedModel.premium {
            (cell as! VideoOverlayCell).video = video
            (cell as! VideoOverlayCell).titleLabel.text = video.title
            (cell as! VideoOverlayCell).playerView.loadWithVideoId(video.id)
        } else {
            (cell as! VideoCell).video = video
            (cell as! VideoCell).titleLabel.text = video.title
            (cell as! VideoCell).playerView.loadWithVideoId(video.id)
            (cell as! VideoCell).setStarFill()
        }
        cell.selectionStyle = .None

        return cell
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
