//
//  MovementsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/13/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class MovementsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    // constants
    fileprivate let reuseIdentifier = "cell"
    fileprivate let screenSizeWithMargins = UIScreen.main.bounds.width - 32
    fileprivate let lightBlueColor: UIColor = UIColor(red: 0.568627451, green: 0.7333333333, blue: 0.968627451, alpha: 1.0)
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    // variables
    fileprivate var movements = [Movement]()
    fileprivate var filteredMovements = [Movement]()
    var gifStrings = [(String, String)]()
    
    // methods
    fileprivate func photoForMovement(_ movement: Movement) -> UIImage? {
        return UIImage(named: "profile")!
    }
    
    fileprivate func reloadCollectionView() {
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
        })
    }
    
    func filterContent(_ searchText: String, scope: String = "All") {
        filteredMovements = movements.filter { movement in
            return movement.title.lowercased().contains(searchText.lowercased())
        }
        
        self.reloadCollectionView()
    }
    
    fileprivate func loadMovements() {
        let path = Bundle.main.path(forResource: "movements", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String : AnyObject]]
        for movementData in json {
            let movement = Movement(data: movementData)
            if movement.title != "Rest" {
                self.movements.append(movement)
            }
            self.reloadCollectionView()
        }
    }

    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        movements = [Movement]()
        loadMovements()
        
        // set up search controller
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.layer.borderWidth = 0.0
        self.navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // delegates
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchController.searchBar.text!)
    }

    // navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! MovementDetailViewController
        let indexPath = collectionView?.indexPathsForSelectedItems![0]
        let movement = searchController.isActive ? filteredMovements[indexPath!.row] : movements[indexPath!.row]
        destVC.movement = movement
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMovements.count
        }
        
        return movements.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovementDescriptionCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.clear
        cell.setConstraints()
        
        let movement: Movement?
        if searchController.isActive && searchController.searchBar.text != "" {
            movement = filteredMovements[indexPath.row]
        }
        else {
            movement = movements[indexPath.row]
        }
        
        cell.movement = movement
        cell.titleLabel.text = movement!.title
        cell.imageView.image = movement!.image
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 93, height: 120.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
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
