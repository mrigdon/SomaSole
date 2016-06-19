//
//  AllWorkoutsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/15/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import TagListView
import EPShapes
import XLPagerTabStrip

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

class AllWorkoutsViewController: UITableViewController, UISearchBarDelegate, IndicatorInfoProvider {
    
    // constants
    let filterCellSize: CGFloat = 44
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    let searchBar = UISearchBar()
    
    // variables
    var filteredWorkouts = [Workout]()
    var selectedFilters = [WorkoutTag]()
    var unfilledStarButton: UIBarButtonItem?
    var filledStarButton: UIBarButtonItem?
    var favorites = false
    
    // methods
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func filterContent(searchText: String) {
        // filter for tags
        var tagFilteredWorkouts = [Workout]()
        for workout in favorites ? User.sharedModel.favoriteWorkouts : Workout.sharedWorkouts {
            // if workout.tags contains all of selected filters
            var qualifies = true
            for filter in selectedFilters {
                qualifies = workout.tags.contains(filter)
                if !qualifies {
                    break
                }
            }
            if qualifies {
                tagFilteredWorkouts.insertAlpha(workout)
            }
        }
        
        // filter for search text
        if searchText != "" {
            filteredWorkouts = tagFilteredWorkouts.filter { workout in
                return workout.name.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        else {
            filteredWorkouts = tagFilteredWorkouts
        }
        
        self.reloadTableView()
    }
    
    func loadWorkouts() {
        FirebaseManager.sharedRootRef.childByAppendingPath("workouts").observeEventType(.ChildAdded, withBlock: { snapshot in
            // load workouts
            let workout = Workout(index: Int(snapshot.key)!, data: snapshot.value as! [String : AnyObject])
            Workout.sharedWorkouts.append(workout)
            if User.sharedModel.favoriteWorkoutKeys.contains(workout.index) {
                User.sharedModel.favoriteWorkouts.append(workout)
            }
            
            self.stopProgressHud()
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
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "All Workouts"
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(searchText)
    }

    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // cusomtize navigation controller
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // setup searchBar
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.tintColor = UIColor.blackColor()
        searchBar.layer.borderWidth = 0.0
        searchBar.layer.borderColor = UIColor.whiteColor().CGColor
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .Done
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        // set up bar buttons
        unfilledStarButton = UIBarButtonItem(image: UIImage(named: "star_unfilled"), style: .Plain, target: self, action: #selector(tappedUnfilledStar))
        unfilledStarButton?.tintColor = UIColor.goldColor()
        filledStarButton = UIBarButtonItem(image: UIImage(named: "star_filled"), style: .Plain, target: self, action: #selector(tappedFilledStar))
        filledStarButton?.tintColor = UIColor.goldColor()
        navigationItem.rightBarButtonItem = unfilledStarButton
        
        // begin load of all workouts
        startProgressHud()
        loadWorkouts()
        
        // no extra cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // auto resize based on centent
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = workoutCellSize
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
            return selectedFilters.count > 0 ? filteredWorkouts.count + 1 : filteredWorkouts.count
        }
        
        return favorites ? User.sharedModel.favoriteWorkouts.count + 1 : Workout.sharedWorkouts.count + 1 // plus one for the filter cell
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = selectedFilters.count > 0 && indexPath.row == 0 ? "tagCell" : indexPath.row == 0 ? "filterCell" : indexPath.row < 3 || User.sharedModel.premium ? "workoutCell" : "workoutOverlayCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellType, forIndexPath: indexPath)
        
        if selectedFilters.count > 0 && indexPath.row == 0 {
            (cell as! TagCell).addFilters(selectedFilters)
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = workoutCellSize
        } else if indexPath.row == 0 {
            self.tableView.rowHeight = filterCellSize
        } else {
            self.tableView.rowHeight = workoutCellSize
            let workoutIndex = indexPath.row - 1 // -1 for the filter cell
            let workout = searchBar.isFirstResponder() && searchBar.text != "" ? filteredWorkouts[workoutIndex] : (favorites ? User.sharedModel.favoriteWorkouts[workoutIndex] : Workout.sharedWorkouts[workoutIndex])
            if indexPath.row < 3 || User.sharedModel.premium {
                (cell as! WorkoutCell).workout = workout
                (cell as! WorkoutCell).setStarFill()
            }
            cell.selectionStyle = .None
            cell.backgroundView = UIImageView(image: workout.image)
        }

        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "workoutSegue" {
            let beginVC = segue.destinationViewController as! BeginWorkoutViewController
            let index = self.tableView.indexPathForSelectedRow?.row
            beginVC.workout = Workout.sharedWorkouts[index!]
        } else if segue.identifier == "tagListSegue" || segue.identifier == "filterSegue" {
            // Get the new view controller using segue.destinationViewController.
            let filterVC = segue.destinationViewController as! FilterViewController
            
            // Pass the selected object to the new view controller.
            filterVC.selectedFilters = self.selectedFilters
            filterVC.addFilterClosure = { filter, adding in
                if adding {
                    self.selectedFilters.append(filter)
                }
                else {
                    let index = self.selectedFilters.indexOf(filter)
                    self.selectedFilters.removeAtIndex(index!)
                }
                self.filterContent("")
            }
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

}
