//
//  News2ViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/20/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import KASlideShow
import youtube_ios_player_helper
import Firebase
import SwiftyJSON
import Alamofire
import AlamofireImage

extension News2ViewController: KASlideShowDelegate {
    func kaSlideShowDidShowNext(slideShow: KASlideShow!) {
        pageControl.currentPage = Int(slideshow.currentIndex)
    }
    
    func kaSlideShowDidShowPrevious(slideShow: KASlideShow!) {
        pageControl.currentPage = Int(slideshow.currentIndex)
    }
}

class News2ViewController: UIViewController {
    
    // constants
    let screenWidth = UIScreen.mainScreen().bounds.width
    let slideshowRatio: CGFloat = 0.6323529412
    let workoutRatio: CGFloat = 0.51575
    
    // variables
    var articles = [Article]()
    var workout: Workout?
    var videos = [Video]()
    var movementIndex = 0
    var setupIndex = 0
    var setupsLoaded = false
    var movementsLoaded = false
    var selectedVideo: Video?
    var slideshow = KASlideShow()
    var pageControl = UIPageControl()

    // outlets
    @IBOutlet weak var slideshowView: QuickStartView!
    @IBOutlet weak var workoutView: QuickStartView!
    @IBOutlet weak var workoutViewHeight: NSLayoutConstraint!
    @IBOutlet weak var slideshowHeight: NSLayoutConstraint!
    @IBOutlet var videoThumbnailViews: [QuickStartView]!
    
    // methods
    private func ui(block: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            block()
        }
    }
    
    @objc private func tappedArticle() {
        performSegueWithIdentifier("articleSegue", sender: self)
    }
    
    @objc private func tappedWorkout(tap: AnyObject) {
        performSegueWithIdentifier("workoutSegue", sender: self)
    }
    
    @objc private func tappedVideoThumbnail(tap: UITapGestureRecognizer) {
        let videoThumbnailView = tap.view as! VideoThumbnailView
        selectedVideo = self.videos[videoThumbnailView.index]
        if selectedVideo != nil {
            performSegueWithIdentifier("videoSegue", sender: self)
        }
    }
    
    private func setupNavbar() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    private func setupSlideshow() {
        let placeholder = WorkoutPlaceholderView()
        slideshowView.delegate = placeholder
        slideshowView.subview = placeholder
        
        slideshowHeight.constant = screenWidth * slideshowRatio
        slideshow.transitionDuration = 1
        slideshow.transitionType = .Slide
        slideshow.imagesContentMode = .ScaleAspectFill
        slideshow.addGesture(.Swipe)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedArticle))
        slideshow.addGestureRecognizer(tap)
        slideshow.delegate = self
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(nextSlide), userInfo: nil, repeats: true)
    }
    
    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.layer.zPosition = 1
    }
    
    private func setupWorkout() {
        workoutViewHeight.constant = (screenWidth - 16) * workoutRatio
        let placeholder = WorkoutPlaceholderView()
        workoutView.delegate = placeholder
        workoutView.subview = placeholder
    }
    
    private func setupVideos() {
        for view in videoThumbnailViews {
            let placeholder = WorkoutPlaceholderView()
            view.delegate = placeholder
            view.subview = placeholder
        }
    }
    
    private func addArticles(json: JSON) {
        for (key, data) in json {
            let article = Article(date: key, data: data.dictionaryObject as! [String:String])
            articles.append(article)
            article.loadTextImage {
                self.slideshow.addImage(article.textImage)
                self.pageControl.numberOfPages = self.articles.count
                self.slideshowView.subview = self.slideshow
                self.slideshowView.addSubview(self.pageControl)
                self.pageControl.snp_makeConstraints(closure: { make in
                    make.bottom.equalTo(self.slideshowView)
                    make.centerX.equalTo(self.slideshowView)
                })
            }
        }
    }
    
    private func addVideos(json: JSON) {
        for (key, data) in json {
            let video = Video(id: key, data: data.dictionaryObject!)
            Alamofire.request(.GET, "http://img.youtube.com/vi/\(video.id)/mqdefault.jpg").responseImage(completionHandler: { response in
                if let image = response.result.value {
                    video.image = image
                    let videoThumbnailView = self.videoThumbnailViews[self.videos.count]
                    let videoView = FeaturedVideoView(image: video.image, title: video.title, frame: videoThumbnailView.frame, index: self.videos.count)
                    videoThumbnailView.subview = videoView
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedVideoThumbnail(_:)))
                    videoThumbnailView.userInteractionEnabled = true
                    videoThumbnailView.addGestureRecognizer(tap)
                    
                    self.videos.append(video)
                }
            })
        }
    }
    
    private func addWorkout(json: JSON) {
        workout = Workout(name: json["index"].stringValue, data: json["data"].dictionaryObject!)
        if let workout = workout {
            workout.loadImage {
                let workoutImageView = QuickStartImageView(image: workout.image)
                workoutImageView.image = workout.image
                workoutImageView.workout = workout
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedWorkout(_:)))
                workoutImageView.userInteractionEnabled = true
                workoutImageView.addGestureRecognizer(tap)
                self.workoutView.subview = workoutImageView
            }
        }
    }
    
    private func loadFeatured() {
        FirebaseManager.sharedRootRef.child("featured_new").observeSingleEventOfType(.Value, withBlock: { snapshot in
            let featured = JSON(snapshot.value!)
            self.addArticles(featured["articles"])
            self.addWorkout(featured["workout"])
            self.addVideos(featured["videos"])
        })
    }
    
    @objc private func nextSlide() {
        slideshow.next()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupSlideshow()
        setupPageControl()
        setupWorkout()
        setupVideos()
        
        loadFeatured()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleSegue" {
            let destVC = segue.destinationViewController as! ArticleViewController
            destVC.article = articles[pageControl.currentPage]
        } else if segue.identifier == "workoutSegue" {
            let destVC = segue.destinationViewController as! UINavigationController
            let rootVC = destVC.viewControllers.first as! BeginWorkoutViewController
            rootVC.workout = workout
            rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: rootVC, action: #selector(BeginWorkoutViewController.dismiss))
        } else if segue.identifier == "videoSegue" {
            let destVC = segue.destinationViewController as! UINavigationController
            let rootVC = destVC.viewControllers.first as! PlayVideoViewController
            rootVC.video = selectedVideo
            rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: rootVC, action: #selector(PlayVideoViewController.dismiss))
        }
    }

}
