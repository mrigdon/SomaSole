//
//  AllVideosViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/28/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import youtube_ios_player_helper
//import StoreKit

extension Array where Element: Video {
    var titles: [String] {
        var titles = [String]()
        for video in self {
            titles.append(video.title)
        }
        return titles
    }
}

//extension AllVideosViewController: IndexedStarDelegate {
//    func didTapStar<T>(star: IndexedStar<T>) {
//        let video = star.data as! Video
//        
//        if star.active {
//            video.favorite = true
//            Video.sharedFavorites.append(video)
//        } else {
//            video.favorite = false
//            Video.sharedFavorites.removeAtIndex(Video.sharedFavorites.indexOf(video)!)
//        }
//        
//        NSUserDefaults.standardUserDefaults().setObject(Video.sharedFavorites.titles, forKey: "favoriteVideoKeys")
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
//}

class AllVideosViewController: UITableViewController, UISearchBarDelegate {
    
    // constants
    let searchBar = UISearchBar()
    let videoCellSize: CGFloat = 250
    
    // variables
    var favoriteVideoKeys = UserDefaults.standard.object(forKey: "favoriteVideoKeys") as? [String]
    var videos = [Video]()
    var filteredVideos = [Video]()
    var unfilledStarButton: UIBarButtonItem?
    var filledStarButton: UIBarButtonItem?
    var favorites = false
    
    // methods
    @objc fileprivate func tappedOverlay() {
        performSegue(withIdentifier: "paymentSegue", sender: self)
    }
    
    fileprivate func reloadTableView() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    fileprivate func loadPublic() {
        Backend.shared.getVideos { videos in
            self.videos = videos
            
            for video in self.videos {
                if let keys = self.favoriteVideoKeys {
                    if keys.contains(video.title) {
                        Video.sharedFavorites.append(video)
                        video.favorite = true
                    }
                }
                
                video.loadImage {
                    self.reloadTableView()
                }
            }
            
            self.stopProgressHud()
            self.reloadTableView()
        }
    }
    
    fileprivate func filterContentForSearchText(_ searchText: String) {
        filteredVideos = (favorites ? Video.sharedFavorites : videos).filter { video in
            return video.title.lowercased().contains(searchText.lowercased())
        }
        
        reloadTableView()
    }
    
    @objc fileprivate func tappedUnfilledStar() {
        // switch to favorites
        navigationItem.rightBarButtonItem = filledStarButton
        favorites = true
        reloadTableView()
    }
    
    @objc fileprivate func tappedFilledStar() {
        // switch to non-favorites
        navigationItem.rightBarButtonItem = unfilledStarButton
        favorites = false
        reloadTableView()
    }
    
    // delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    fileprivate func setupNav() {
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        unfilledStarButton = UIBarButtonItem(image: UIImage(named: "star_unfilled"), style: .plain, target: self, action: #selector(tappedUnfilledStar))
        unfilledStarButton?.tintColor = UIColor.goldColor()
        filledStarButton = UIBarButtonItem(image: UIImage(named: "star_filled"), style: .plain, target: self, action: #selector(tappedFilledStar))
        filledStarButton?.tintColor = UIColor.goldColor()
        navigationItem.rightBarButtonItem = unfilledStarButton
    }
    
    fileprivate func setupSearchBar() {
        searchBar.barTintColor = UIColor.white
        searchBar.tintColor = UIColor.black
        searchBar.layer.borderWidth = 0.0
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    fileprivate func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = videoCellSize
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isFirstResponder && searchBar.text != "" {
            return filteredVideos.count
        }
        
        return favorites ? Video.sharedFavorites.count : videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = searchBar.isFirstResponder && searchBar.text != "" ? filteredVideos[indexPath.row] : (favorites ? Video.sharedFavorites[indexPath.row] : videos[indexPath.row])
        
        let reuseID = "newVideoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        cell.contentView.clearSubviews()
        let containerView = ContainerView()
        cell.contentView.addSubviewWithConstraints(containerView, height: nil, width: nil, top: 0, left: 0, right: 0, bottom: 0)
        if video.image != nil {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = videoCellSize
            let videoView = VideoCellView()
            videoView.video = video
//            videoView.star.delegate = self
            (cell as! NewVideoCell).video = video
            containerView.delegate = nil
            containerView.subview = videoView
        } else {
            tableView.rowHeight = videoCellSize
            let placeholder = VideoCellPlaceholderView()
            placeholder.size = videoCellSize
            containerView.delegate = placeholder
            containerView.subview = placeholder
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "newVideoSegue" {
            let indexPath = tableView.indexPathForSelectedRow
            let cell = tableView.cellForRow(at: indexPath!) as! NewVideoCell
            
            return cell.video != nil
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newVideoSegue" {
            let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! NewVideoCell
            (segue.destination as! PlayVideoViewController).video = cell.video
        }
    }

}
