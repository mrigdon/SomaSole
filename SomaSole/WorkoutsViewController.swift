//
//  WorkoutsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/15/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import TagListView

extension WorkoutsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContent(searchController.searchBar.text!)
    }
}

class WorkoutsViewController: UITableViewController {
    
    // constants
    let firebase = Firebase(url: "http://somasole.firebaseio.com")
    let filterCellSize: CGFloat = 44
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.mainScreen().bounds.width
    let lightBlueColor: UIColor = UIColor(red: 0.568627451, green: 0.7333333333, blue: 0.968627451, alpha: 1.0)
    let searchController = UISearchController(searchResultsController: nil)
    
    // variables
    var workouts = [Workout]()
    var filteredWorkouts = [Workout]()
    var selectedFilters = [WorkoutTag]()
    
    // outlets
    @IBOutlet weak var tagListView: TagListView!
    
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
    
    func filterContent(searchText: String, scope: String = "All") {
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
    
    func loadWorkouts() {
        firebase.childByAppendingPath("workouts").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            // load workouts
            let workout = Workout(index: Int(snapshot.key)!, data: snapshot.value as! [String : AnyObject])
            workout.loadImage({self.reloadTableView()})
            self.workouts.append(workout)
            
            self.stopProgressHud()
            self.reloadTableView()
        })
        
    }

    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // begin load of all workouts
        startProgressHud()
        loadWorkouts()
        
        // set up search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["All", "Favorites"]
        searchController.searchBar.barTintColor = lightBlueColor
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.layer.borderWidth = 0.0
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // no extra cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // auto resize based on centent
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = workoutCellSize
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active || selectedFilters.count > 0 {
            return filteredWorkouts.count + 1
        }
        
        return workouts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get correct cellType
        var cellType = ""
        if searchController.active && indexPath.row == 0 {
            cellType = selectedFilters.count > 0 ? "tagCell" : "cell"
        }
        else {
            cellType = selectedFilters.count > 0 && indexPath.row == 0 ? "tagCell" : "workoutCell"
        }
        
        // create cell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellType, forIndexPath: indexPath)
        
        // customize cell for each case
        if !searchController.active {
            if selectedFilters.count > 0 && indexPath.row == 0 {
                // filter cell with tags
                (cell as! TagCell).addFilters(selectedFilters)
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = workoutCellSize
            }
            else {
                // all workouts
                self.tableView.rowHeight = workoutCellSize
                let workout = workouts[indexPath.row]
                (cell as! WorkoutCell).workout = workout
                if let image = (cell as! WorkoutCell).workout!.image {
                    cell.backgroundView = UIImageView(image: image)
                }
                else {
                    cell.backgroundView = nil
                }
            }
        }
        else if indexPath.row == 0 {
            if selectedFilters.count == 0 {
                // filter cell with no tags
                self.tableView.rowHeight = filterCellSize
            }
            else {
                // filter cell with tags
                (cell as! TagCell).addFilters(selectedFilters)
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = workoutCellSize
            }
        }
        else {
            // filtered workouts
            self.tableView.rowHeight = workoutCellSize
            let workout = filteredWorkouts[indexPath.row - 1] // - 1 because of the tag cell
            (cell as! WorkoutCell).workout = workout
            if let image = (cell as! WorkoutCell).workout!.image {
                cell.backgroundView = UIImageView(image: image)
            }
            else {
                cell.backgroundView = nil
            }
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
