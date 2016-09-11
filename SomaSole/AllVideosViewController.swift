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
import AlamofireImage
import Alamofire
import MBProgressHUD
import StoreKit

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

class AllVideosViewController: UITableViewController, UISearchBarDelegate {
    
    // constants
    let searchBar = UISearchBar()
    
    // variables
    var favoriteVideoKeys = NSUserDefaults.standardUserDefaults().objectForKey("favoriteVideoKeys") as? [String]
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
        FirebaseManager.sharedRootRef.child("videos/public").observeEventType(.ChildAdded, withBlock: { snapshot in
            let video = Video(id: snapshot.key, data: snapshot.value as! [String : AnyObject])
            video.free = true
            if let keys = self.favoriteVideoKeys {
                if keys.contains(video.title) {
                    Video.sharedFavorites.append(video)
                }
            }
            
            Alamofire.request(.GET, "http://img.youtube.com/vi/\(video.id)/mqdefault.jpg").responseImage(completionHandler: { response in
                if let image = response.result.value {
                    video.image = image
                    self.videos.append(video)
                    self.reloadTableView()
                    self.stopProgressHud()
                }
            })
        })
    }
    
    private func loadPrivate() {
        FirebaseManager.sharedRootRef.child("videos/private").observeEventType(.ChildAdded, withBlock: { snapshot in
            let video = Video(id: snapshot.key, data: snapshot.value as! [String:AnyObject])
            video.free = false
            if let keys = self.favoriteVideoKeys {
                if keys.contains(video.title) {
                    Video.sharedFavorites.append(video)
                }
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
        filteredVideos = (favorites ? Video.sharedFavorites : videos).filter { video in
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
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    private func setupNav() {
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        unfilledStarButton = UIBarButtonItem(image: UIImage(named: "star_unfilled"), style: .Plain, target: self, action: #selector(tappedUnfilledStar))
        unfilledStarButton?.tintColor = UIColor.goldColor()
        filledStarButton = UIBarButtonItem(image: UIImage(named: "star_filled"), style: .Plain, target: self, action: #selector(tappedFilledStar))
        filledStarButton?.tintColor = UIColor.goldColor()
        navigationItem.rightBarButtonItem = unfilledStarButton
    }
    
    private func setupSearchBar() {
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.tintColor = UIColor.blackColor()
        searchBar.layer.borderWidth = 0.0
        searchBar.layer.borderColor = UIColor.whiteColor().CGColor
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .Done
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 274
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupSearchBar()
        setupTableView()

        startProgressHud()
        loadPublic()
//        loadPrivate()
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        return favorites ? Video.sharedFavorites.count : videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let video = searchBar.isFirstResponder() && searchBar.text != "" ? filteredVideos[indexPath.row] : (favorites ? Video.sharedFavorites[indexPath.row] : videos[indexPath.row])
        
        let reuseID = video.free || User.sharedModel.premium ? "videoCell" : "videoOverlayCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID, forIndexPath: indexPath)
//        let cell = tableView.dequeueReusableCellWithIdentifier("newVideoCell", forIndexPath: indexPath)
        
        if video.free || User.sharedModel.premium {
            (cell as! VideoCell).video = video
            (cell as! VideoCell).titleLabel.text = video.title
            (cell as! VideoCell).videoImageView.image = video.image
            (cell as! VideoCell).titleLabel.sizeToFit()
            (cell as! VideoCell).setStarFill()
//            let videoView = VideoCellView()
//            videoView.label.text = video.title
//            videoView.imageView.image = video.image
//            cell.contentView.addSubviewWithConstraints(videoView, height: nil, width: nil, top: 0, left: 0, right: 0, bottom: 0)
            
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

}
