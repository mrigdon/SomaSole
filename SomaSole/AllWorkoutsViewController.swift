//
//  AllWorkoutsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/15/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import TagListView
import Firebase
import EPShapes

extension Array where Element: Workout {
    mutating func insertAlpha(workout: Element) {
        if self.count == 0 {
            self.append(workout)
            return
        }
        
        for (index, item) in self.enumerate() {
            if workout.name.localizedCompare(item.name) == .OrderedAscending {
                self.insert(workout, atIndex: index)
                return
            }
        }
        
        self.append(workout)
    }
}

class AllWorkoutsViewController: UITableViewController, UISearchBarDelegate {
    
    // constants
    let filterCellSize: CGFloat = 44
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    let searchBar = UISearchBar()
    
    // variables
    var workouts = [Workout]()
    var favoriteWorkoutKeys = NSUserDefaults.standardUserDefaults().objectForKey("favoriteWorkoutKeys") as? [String]
    var filteredWorkouts = [Workout]()
    var selectedFilters = [WorkoutTag]()
    var unfilledStarButton: UIBarButtonItem?
    var filledStarButton: UIBarButtonItem?
    var favorites = false
    
    // methods
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func filterContent(searchText: String) {
        // filter for tags
        var tagFilteredWorkouts = selectedFilters.count > 0 ? [Workout]() : favorites ? Workout.sharedFavorites : workouts
        for workout in favorites ? Workout.sharedFavorites : workouts {
            for filter in selectedFilters {
                if workout.tags.contains(filter) {
                    tagFilteredWorkouts.insertAlpha(workout)
                    break
                }
            }
        }
        
        // filter for search text
        if searchText != "" {
            filteredWorkouts = tagFilteredWorkouts.filter { workout in
                return workout.name.lowercaseString.containsString(searchText.lowercaseString)
            }
        } else {
            filteredWorkouts = tagFilteredWorkouts
        }
        
        self.reloadTableView()
    }
    
//    private func loadPublicWorkouts() {
//        FirebaseManager.sharedRootRef.child("workouts/public").observeEventType(.ChildAdded, withBlock: { snapshot in
//            // load workouts
//            let workout = Workout(name: snapshot.key, data: snapshot.value as! [String : AnyObject])
//            workout.free = true
//            self.workouts.append(workout)
//            if let keys = self.favoriteWorkoutKeys {
//                if keys.contains(workout.name) {
//                    Workout.sharedFavorites.append(workout)
//                }
//            }
//            
//            self.stopProgressHud()
//            self.reloadTableView()
//        })
//        
//    }
    
    private func loadPublicWorkouts() {
        FirebaseManager.sharedRootRef.child("workouts_new/public").observeEventType(.ChildAdded, withBlock: { snapshot in
            // load workouts
            let workout = Workout(name: snapshot.key, data: snapshot.value as! [String : AnyObject])
            workout.free = true
            self.workouts.append(workout)
            if let keys = self.favoriteWorkoutKeys {
                if keys.contains(workout.name) {
                    Workout.sharedFavorites.append(workout)
                }
            }
            
            workout.loadImage {
                self.reloadTableView()
            }
        })
        
    }
    
    private func loadPrivateWorkouts() {
        FirebaseManager.sharedRootRef.child("workouts/private").observeEventType(.ChildAdded, withBlock: { snapshot in
            // load workouts
            let workout = Workout(name: snapshot.key, data: snapshot.value as! [String : AnyObject])
            workout.free = false
            self.workouts.append(workout)
            if let keys = self.favoriteWorkoutKeys {
                if keys.contains(workout.name) {
                    Workout.sharedFavorites.append(workout)
                }
            }
            
            self.reloadTableView()
        })
        
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
        filterContent(searchText)
    }
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
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
    
    private func setupBarButtons() {
        unfilledStarButton = UIBarButtonItem(image: UIImage(named: "star_unfilled"), style: .Plain, target: self, action: #selector(tappedUnfilledStar))
        unfilledStarButton?.tintColor = UIColor.goldColor()
        filledStarButton = UIBarButtonItem(image: UIImage(named: "star_filled"), style: .Plain, target: self, action: #selector(tappedFilledStar))
        filledStarButton?.tintColor = UIColor.goldColor()
        navigationItem.rightBarButtonItem = unfilledStarButton
    }
    
    private func setupTableView() {
        // no extra cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // auto resize based on centent
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = workoutCellSize
    }

    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // ui setup
        setupNavigationController()
        setupSearchBar()
        setupBarButtons()
        
        // begin load of all workouts
        loadPublicWorkouts()
//        loadPrivateWorkouts()
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadTableView()
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
        if (searchBar.isFirstResponder() && searchBar.text != "") || selectedFilters.count > 0 {
            return filteredWorkouts.count + 1
        }
        
        return favorites ? Workout.sharedFavorites.count + 1 : workouts.count + 1 // plus one for the filter cell
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellType = ""
        var workout: Workout?
        if selectedFilters.count > 0 && indexPath.row == 0 {
            cellType = "tagCell"
        } else if indexPath.row == 0 {
            cellType = "filterCell"
        } else {
            let workoutIndex = indexPath.row - 1 // -1 for the filter cell
            workout = searchBar.isFirstResponder() && searchBar.text != "" ? filteredWorkouts[workoutIndex] : (favorites ? Workout.sharedFavorites[workoutIndex] : workouts[workoutIndex])
            if workout!.free || User.sharedModel.premium {
                cellType = "workoutCell"
            } else {
                cellType = "workoutOverlayCell"
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellType, forIndexPath: indexPath)
        
        if selectedFilters.count > 0 && indexPath.row == 0 {
            // tags cell
            (cell as! TagCell).addFilters(selectedFilters)
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = workoutCellSize
        } else if indexPath.row == 0 {
            // filter button cell
            self.tableView.rowHeight = filterCellSize
        } else {
            // workout cell
            self.tableView.rowHeight = workoutCellSize
            let workoutIndex = indexPath.row - 1 // -1 for the filter cell
            let workout = (searchBar.isFirstResponder() && searchBar.text != "") || selectedFilters.count > 0 ? filteredWorkouts[workoutIndex] : favorites ? Workout.sharedFavorites[workoutIndex] : workouts[workoutIndex]
            if workout.free || User.sharedModel.premium {
                (cell as! WorkoutCell).workout = workout
                (cell as! WorkoutCell).setStarFill()
            }
            cell.selectionStyle = .None
            
            let cellView = ContainerView()
            cell.contentView.addSubview(cellView)
            cellView.snp_makeConstraints(closure: { make in
                make.top.equalTo(cell.contentView)
                make.left.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView)
            })
            if let image = workout.image {
                cellView.delegate = nil
                cellView.subview = UIImageView(image: image)
//                cellView.addSubviewWithConstraints(IndexedStarButton(), height: 30, width: 30, top: 8, left: nil, right: 8, bottom: nil)
            } else {
                let placeholder = WorkoutCellPlaceholderView()
                placeholder.size = workoutCellSize
                cellView.delegate = placeholder
                cellView.subview = placeholder
            }
        }

        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "workoutSegue" {
            let beginVC = segue.destinationViewController as! BeginWorkoutViewController
            let cell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!) as! WorkoutCell
            beginVC.workout = cell.workout
        } else if segue.identifier == "tagListSegue" || segue.identifier == "filterSegue" {
            // Get the new view controller using segue.destinationViewController.
            let filterVC = segue.destinationViewController as! FilterViewController
            
            // Pass the selected object to the new view controller.
            filterVC.selectedFilters = self.selectedFilters
            filterVC.addFilterClosure = { filter, adding in
                if adding {
                    self.selectedFilters.append(filter)
                } else {
                    let index = self.selectedFilters.indexOf(filter)
                    self.selectedFilters.removeAtIndex(index!)
                }
                self.filterContent("")
            }
        }
    }

}
