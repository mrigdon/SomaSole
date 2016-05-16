//
//  MovementsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/13/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase

class MovementsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    // constants
    private let reuseIdentifier = "cell"
    private let screenSizeWithMargins = UIScreen.mainScreen().bounds.width - 32
    private let firebase = Firebase(url: "http://somasole.firebaseio.com")
    private let lightBlueColor: UIColor = UIColor(red: 0.568627451, green: 0.7333333333, blue: 0.968627451, alpha: 1.0)
    private let searchController = UISearchController(searchResultsController: nil)
    
    // variables
    private var movements = [Movement]()
    private var filteredMovements = [Movement]()
    
    // methods
    private func photoForIndexPath(indexPath: NSIndexPath) -> UIImage {
        return UIImage(named: "profile")!
    }
    
    private func reloadCollectionView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView?.reloadData()
        })
    }
    
    func filterContent(searchText: String, scope: String = "All") {
        filteredMovements = movements.filter { movement in
            return movement.title.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        self.reloadCollectionView()
    }
    
    private func loadMovements() {
        firebase.childByAppendingPath("movements").observeSingleEventOfType(.Value, withBlock: { snapshot in
            let movementsData = snapshot.value as! [AnyObject]
            for movementData in movementsData {
                self.movements.append(Movement(data: movementData as! [String:String]))
            }
            self.reloadCollectionView()
        })
    }

    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // set up search controller
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = lightBlueColor
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.layer.borderWidth = 0.0
        self.navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        loadMovements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // delegates
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContent(searchController.searchBar.text!)
    }

    // navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! MovementDetailViewController
        let indexPath = collectionView?.indexPathsForSelectedItems()![0]
        let movement = searchController.active ? filteredMovements[indexPath!.row] : movements[indexPath!.row]
        destVC.movement = movement
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredMovements.count
        }
        
        return movements.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovementDescriptionCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.clearColor()
        cell.imageView.image = photoForIndexPath(indexPath)
        cell.setConstraints()
        
        let movement: Movement?
        if searchController.active && searchController.searchBar.text != "" {
            movement = filteredMovements[indexPath.row]
        }
        else {
            movement = movements[indexPath.row]
        }
        
        cell.movement = movement
        cell.titleLabel.text = movement!.title
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 129)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
