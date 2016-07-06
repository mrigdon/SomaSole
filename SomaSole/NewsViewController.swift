//
//  NewsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/25/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import KASlideShow
import Firebase
import MBProgressHUD

extension UIColor {
    static func somasoleColor() -> UIColor { return UIColor(red: 65/255, green: 182/255, blue: 230/255, alpha: 1.0) }
}

class NewsViewController: UIViewController, UIScrollViewDelegate, KASlideShowDelegate {
    
    // constants
    let screenWidth = UIScreen.mainScreen().bounds.width
    let navbarImageHeight: Double = 40
    let navbarImageWidth: Double = 63.2
    
    // variables
    var articles = [Article]()
    var workouts = [Workout]()
    var selectedWorkout: Workout?
    var movementIndex = 0

    // outlets
    @IBOutlet weak var slideshow: KASlideShow!
    @IBOutlet weak var slideshowHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var imageViewCollection: [QuickStartImageView]!
    @IBOutlet weak var navItemImageView: UIImageView!
    
    // methods
    @objc private func tappedArticle() {
        performSegueWithIdentifier("articleSegue", sender: self)
    }
    
    @objc private func tappedWorkout(tap: AnyObject) {
        selectedWorkout = (tap.view!! as! QuickStartImageView).workout
        loadMovements()
    }
    
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    private func setupSlideshow() {
        slideshowHeightConstraint.constant = screenWidth
        slideshow.delay = 3
        slideshow.transitionDuration = 1
        slideshow.transitionType = .Slide
        slideshow.imagesContentMode = .ScaleToFill
        slideshow.delay = 2
        slideshow.addGesture(.Swipe)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedArticle))
        slideshow.addGestureRecognizer(tap)
        slideshow.delegate = self
    }
    
    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.layer.zPosition = 1
    }
    
    private func setupRecommended() {
        
    }
    
    private func addArticle(article: Article) {
        articles.append(article)
        slideshow.addImage(article.image)
        pageControl.numberOfPages = articles.count
    }
    
    private func addWorkout(workout: Workout, index: Int) {
        workouts.append(workout)
        imageViewCollection[index].image = workout.image
        imageViewCollection[index].workout = workout
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewsViewController.tappedWorkout(_:)))
        imageViewCollection[index].userInteractionEnabled = true
        imageViewCollection[index].addGestureRecognizer(tap)
    }
    
    private func loadArticles() {
        FirebaseManager.sharedRootRef.childByAppendingPath("articles").observeEventType(.ChildAdded, withBlock: { snapshot in
            let article = Article(date: snapshot.key, data: snapshot.value as! [String : String])
            self.addArticle(article)
            
        })
    }
    
    private func loadWorkouts() {
        for index in 0...3 {
            FirebaseManager.sharedRootRef.childByAppendingPath("workouts/public").childByAppendingPath(String(index)).observeSingleEventOfType(.Value, withBlock: { snapshot in
                let workout = Workout(name: snapshot.key, data: snapshot.value as! [String : AnyObject])
                self.addWorkout(workout, index: index)
            })
        }
    }
    
    func loadMovements() {
        startProgressHud()
        for circuit in selectedWorkout!.circuits {
            for movement in circuit.movements {
                FirebaseManager.sharedRootRef.childByAppendingPath("movements").childByAppendingPath(String(movement.index)).observeEventType(.Value, withBlock: { snapshot in
                    movement.title = snapshot.value["title"] as! String
                    movement.movementDescription = snapshot.value["description"] as? String
                    movement.decodeImage(snapshot.value["jpg"] as! String)
                    movement.loadGif({
                        self.movementIndex += 1
                        if self.movementIndex == self.selectedWorkout!.numMovements {
                            self.movementIndex = 0
                            self.stopProgressHud()
                            self.performSegueWithIdentifier("workoutSegue", sender: self)
                        }
                    })
                })
            }
        }
    }
    
    @objc private func nextSlide() {
        slideshow.next()
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav bar setup
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // add'l setup
        setupSlideshow()
        setupPageControl()
        setupRecommended()
        loadArticles()
        loadWorkouts()
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(nextSlide), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // slideshow
    func kaSlideShowDidShowNext(slideShow: KASlideShow!) {
        pageControl.currentPage = Int(slideshow.currentIndex)
    }
    
    func kaSlideShowDidShowPrevious(slideShow: KASlideShow!) {
        pageControl.currentPage = Int(slideshow.currentIndex)
    }

    // navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleSegue" {
            let destVC = segue.destinationViewController as! ArticleViewController
            destVC.article = articles[pageControl.currentPage]
        }
        else if segue.identifier == "workoutSegue" {
            let destVC = segue.destinationViewController as! InWorkoutViewController
            destVC.workout = selectedWorkout
        }
    }

}
