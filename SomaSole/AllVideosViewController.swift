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
import AlamofireImage
import Alamofire
import MBProgressHUD

extension Array where Element: Video {
    mutating func appendAfterPublic(video: Element) {
        if self.count == 0 {
            self.append(video)
            return
        }
        
        for (index, item) in self.enumerate() {
            if !item.free {
                if index + 1 < self.count {
                    self.insert(video, atIndex: index + 1)
                    return
                }
                break
            }
        }
        
        self.append(video)
    }
}

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
    private func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    private func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
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
            video.free = true
            if User.sharedModel.favoriteVideoKeys.contains(video.id) {
                User.sharedModel.favoriteVideos.append(video)
            }
            
            Alamofire.request(.GET, "http://img.youtube.com/vi/\(video.id)/mqdefault.jpg").responseImage(completionHandler: { response in
                if let image = response.result.value {
                    video.image = image
                    self.videos.insert(video, atIndex: 0)
                    self.reloadTableView()
                    self.stopProgressHud()
                }
            })
        })
    }
    
    private func loadPrivate() {
        FirebaseManager.sharedRootRef.childByAppendingPath("videos").childByAppendingPath("private").observeEventType(.ChildAdded, withBlock: { snapshot in
            let video = Video(id: snapshot.key, title: snapshot.value as! String)
            video.free = false
            if User.sharedModel.favoriteVideoKeys.contains(video.id) {
                User.sharedModel.favoriteVideos.append(video)
            }
            
            Alamofire.request(.GET, "http://img.youtube.com/vi/\(video.id)/0.jpg").responseImage(completionHandler: { response in
                if let image = response.result.value {
                    video.image = image
                    self.videos.append(video)
                    self.reloadTableView()
                    self.stopProgressHud()
                }
            })
        })
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

        startProgressHud()
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
        let video = searchBar.isFirstResponder() && searchBar.text != "" ? filteredVideos[indexPath.row] : (favorites ? User.sharedModel.favoriteVideos[indexPath.row] : videos[indexPath.row])
        
        let reuseID = video.free || User.sharedModel.premium ? "videoCell" : "videoOverlayCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID, forIndexPath: indexPath)
        
        if video.free || User.sharedModel.premium {
            (cell as! VideoCell).video = video
            (cell as! VideoCell).titleLabel.text = video.title
            (cell as! VideoCell).videoImageView.image = video.image
            (cell as! VideoCell).titleLabel.sizeToFit()
            (cell as! VideoCell).setStarFill()
        } else {
            (cell as! VideoOverlayCell).video = video
            (cell as! VideoOverlayCell).titleLabel.text = video.title
            (cell as! VideoOverlayCell).videoImageView.image = video.image
            (cell as! VideoOverlayCell).titleLabel.sizeToFit()
        }
        cell.selectionStyle = .None

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "videoSegue" {
            let cell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!) as! VideoCell
            let video = cell.video
            (segue.destinationViewController as! PlayVideoViewController).video = video
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
