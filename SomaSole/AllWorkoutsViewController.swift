//
//  AllWorkoutsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/15/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import TagListView
//import EPShapes
//import MBProgressHUD

extension Array where Element: Workout {
    mutating func insertAlpha(_ workout: Element) {
        if self.count == 0 {
            self.append(workout)
            return
        }
        
        for (index, item) in self.enumerated() {
            if workout.name.localizedCompare(item.name) == .orderedAscending {
                self.insert(workout, at: index)
                return
            }
        }
        
        self.append(workout)
    }
    
    var names: [String] {
        var favoriteWorkouts = [String]()
        for workout in Workout.sharedFavorites {
            favoriteWorkouts.append(workout.name)
        }
        return favoriteWorkouts
    }
}

//extension AllWorkoutsViewController: IndexedStarDelegate {
//    func didTapStar<T>(star: IndexedStar<T>) {
//        let workout = star.data as! Workout
//        
//        if star.active {
//            workout.favorite = true
//            Workout.sharedFavorites.insertAlpha(workout)
//        } else {
//            workout.favorite = false
//            Workout.sharedFavorites.removeAtIndex(Workout.sharedFavorites.indexOf(workout)!)
//        }
//        
//        NSUserDefaults.standardUserDefaults().setObject(Workout.sharedFavorites.names, forKey: "favoriteWorkoutKeys")
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
//}

class AllWorkoutsViewController: UITableViewController, UISearchBarDelegate {
    
    // constants
    let filterCellSize: CGFloat = 44
    let workoutCellSize: CGFloat = 0.51575 * UIScreen.main.bounds.width
    let searchBar = UISearchBar()
    
    // variables
    var workouts = [Workout]()
    var favoriteWorkoutKeys = UserDefaults.standard.object(forKey: "favoriteWorkoutKeys") as? [String]
    var filteredWorkouts = [Workout]()
    var selectedFilters = [WorkoutTag]()
    var unfilledStarButton: UIBarButtonItem?
    var filledStarButton: UIBarButtonItem?
    var favorites = false
    
    // methods
    func reloadTableView() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    fileprivate func startProgressHud() {
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    fileprivate func stopProgressHud() {
        DispatchQueue.main.async(execute: {
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func filterContent(_ searchText: String) {
        // filter for tags
        var tagFilteredWorkouts = selectedFilters.count > 0 ? [Workout]() : favorites ? Workout.sharedFavorites : workouts
        for workout in favorites ? Workout.sharedFavorites : workouts {
            for filter in selectedFilters {
                if workout.tags.map({ $0.tag.workoutTag }).contains(filter) {
                    tagFilteredWorkouts.insertAlpha(workout)
                    break
                }
            }
        }
        
        // filter for search text
        if searchText != "" {
            filteredWorkouts = tagFilteredWorkouts.filter { workout in
                return workout.name.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredWorkouts = tagFilteredWorkouts
        }
        
        self.reloadTableView()
    }
    
    fileprivate func loadPublicWorkouts() {
        startProgressHud()
        Backend.shared.getWorkouts { workouts in
            self.workouts = workouts
            
            for workout in self.workouts {
                if let keys = self.favoriteWorkoutKeys {
                    if keys.contains(workout.name) {
                        Workout.sharedFavorites.append(workout)
                        workout.favorite = true
                    }
                }
                
                workout.loadImage {
                    self.reloadTableView()
                }
            }
            
            self.stopProgressHud()
            self.reloadTableView()
        }
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
    
    fileprivate func cellTypeForIndexPath(_ indexPath: IndexPath) -> String {
        return selectedFilters.count > 0 && indexPath.row == 0 ? "tagCell" : indexPath.row == 0 ? "filterCell" : "workoutCell"
    }
    
    fileprivate func workoutForCell(_ cellType: String, at index: Int) -> Workout? {
        if cellType == "workoutCell" {
            return searchBar.isFirstResponder && searchBar.text != "" ? filteredWorkouts[index] : (favorites ? Workout.sharedFavorites[index] : workouts[index])
        }
        
        return nil
    }
    
    // delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(searchText)
    }
    
    fileprivate func setupNavigationController() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    
    fileprivate func setupBarButtons() {
        unfilledStarButton = UIBarButtonItem(image: UIImage(named: "star_unfilled"), style: .plain, target: self, action: #selector(tappedUnfilledStar))
        unfilledStarButton?.tintColor = UIColor.goldColor()
        filledStarButton = UIBarButtonItem(image: UIImage(named: "star_filled"), style: .plain, target: self, action: #selector(tappedFilledStar))
        filledStarButton?.tintColor = UIColor.goldColor()
        navigationItem.rightBarButtonItem = unfilledStarButton
    }
    
    fileprivate func setupTableView() {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if (searchBar.isFirstResponder && searchBar.text != "") || selectedFilters.count > 0 {
            return filteredWorkouts.count + 1
        }
        
        return favorites ? Workout.sharedFavorites.count + 1 : workouts.count + 1 // plus one for the filter cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypeForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        if cellType == "tagCell" {
            (cell as! TagCell).addFilters(selectedFilters)
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = workoutCellSize
        } else if cellType == "filterCell" {
            self.tableView.rowHeight = filterCellSize
        } else {
            // set workout cell size
            self.tableView.rowHeight = workoutCellSize
            
            // get workout
            let workoutIndex = indexPath.row - 1 // -1 for the filter cell
            let workout = (searchBar.isFirstResponder && searchBar.text != "") || selectedFilters.count > 0 ? filteredWorkouts[workoutIndex] : favorites ? Workout.sharedFavorites[workoutIndex] : workouts[workoutIndex]
            (cell as! WorkoutCell).workout = workout
            
            // better ui for touch
            cell.selectionStyle = .none
            
            // clear subviews
            cell.contentView.clearSubviews()
            
            // add container view
            let cellView = ContainerView()
            cell.contentView.addSubviewWithConstraints(cellView, height: nil, width: nil, top: 0, left: 0, right: 0, bottom: 0)
            if let image = workout.image {
                cellView.delegate = nil
                cellView.subview = UIImageView(image: image)
//                let star = IndexedStar<Workout>(active: workout.favorite)
//                star.delegate = self
//                star.data = workout
//                cellView.addSubviewWithConstraints(star, height: 30, width: 30, top: 8, left: nil, right: 8, bottom: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutSegue" {
            let beginVC = segue.destination as! BeginWorkoutViewController
            let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! WorkoutCell
            beginVC.workout = cell.workout
        } else if segue.identifier == "tagListSegue" || segue.identifier == "filterSegue" {
            // Get the new view controller using segue.destinationViewController.
            let filterVC = segue.destination as! FilterViewController
            
            // Pass the selected object to the new view controller.
            filterVC.selectedFilters = self.selectedFilters
            filterVC.addFilterClosure = { filter, adding in
                if adding {
                    self.selectedFilters.append(filter)
                } else {
                    let index = self.selectedFilters.index(of: filter)
                    self.selectedFilters.remove(at: index!)
                }
                self.filterContent("")
            }
        }
    }

}
