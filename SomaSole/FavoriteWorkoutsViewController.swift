//
//  FavoriteWorkoutsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import TagListView
import MBProgressHUD
import XLPagerTabStrip
import Firebase
import EPShapes

class FavoriteWorkoutsViewController: UITableViewController, IndicatorInfoProvider, UISearchBarDelegate {

    // constants
    let filterCellSize: CGFloat = 44
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    let searchBar = UISearchBar()
    
    // variables
    var workouts = [Workout]()
    var filteredWorkouts = [Workout]()
    var selectedFilters = [WorkoutTag]()
    
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
        for workout in workouts {
            // if workout.tags contains all of selected filters
            var qualifies = true
            for filter in selectedFilters {
                qualifies = workout.tags.contains(filter)
                if !qualifies {
                    break
                }
            }
            if qualifies {
                tagFilteredWorkouts.append(workout)
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
    
    private func loadFavoriteWorkouts() {
        if User.sharedModel.favoriteWorkoutKeys.count > 0 {
            startProgressHud()
        }
        
        for (index, workoutIndex) in User.sharedModel.favoriteWorkoutKeys.enumerate() {
            FirebaseManager.sharedRootRef.childByAppendingPath("workouts").childByAppendingPath(String(workoutIndex)).observeEventType(.Value, withBlock: { snapshot in
                let workout = Workout(index: Int(snapshot.key)!, data: snapshot.value as! [String : AnyObject])
                self.workouts.insert(workout, atIndex: index)
                
                self.stopProgressHud()
                self.reloadTableView()
            })
        }
    }
    
    @objc private func tappedStar(sender: AnyObject) {
        let switchOriginInTableView = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = tableView.indexPathForRowAtPoint(switchOriginInTableView)
        workouts.removeAtIndex(indexPath!.row)
        User.sharedModel.favoriteWorkoutKeys.removeAtIndex(indexPath!.row)
        FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).childByAppendingPath("favoriteWorkoutKeys").setValue(User.sharedModel.favoriteWorkoutKeys)
        User.saveToUserDefaults()
        
        // ui
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
    // delegates
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Favorite Workouts"
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
        
        // no extra cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // auto resize based on centent
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = workoutCellSize
    }
    
    override func viewDidAppear(animated: Bool) {
        workouts = []
        loadFavoriteWorkouts()
        self.reloadTableView()
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
        
        return workouts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = selectedFilters.count > 0 && indexPath.row == 0 ? "tagCell" : "workoutCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellType, forIndexPath: indexPath)
        
        if selectedFilters.count > 0 && indexPath.row == 0 {
            (cell as! TagCell).addFilters(selectedFilters)
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = workoutCellSize
        }
        else {
            self.tableView.rowHeight = workoutCellSize
            let workout = searchBar.isFirstResponder() && searchBar.text != "" ? filteredWorkouts[indexPath.row] : workouts[indexPath.row]
            (cell as! WorkoutCell).workout = workout
            (cell as! WorkoutCell).setStarFill()
            (cell as! WorkoutCell).starButton.addTarget(self, action: #selector(tappedStar(_:)), forControlEvents: .TouchUpInside)
            (cell as! WorkoutCell).starButton.index = indexPath.row
            cell.backgroundView = UIImageView(image: (cell as! WorkoutCell).workout!.image)
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "workoutSegue" {
            let beginVC = segue.destinationViewController as! BeginWorkoutViewController
            let index = self.tableView.indexPathForSelectedRow?.row
            beginVC.workout = workouts[index!]
        }
        else {
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
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
