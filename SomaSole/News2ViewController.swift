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
import MBProgressHUD
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

    // outlets
    @IBOutlet weak var slideshow: KASlideShow!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var workoutImageView: QuickStartImageView!
    @IBOutlet weak var workoutImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var slideshowHeight: NSLayoutConstraint!
    @IBOutlet var videoThumbnailViews: [VideoThumbnailView]!
    
    // methods
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
    
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    private func setupSlideshow() {
        slideshowHeight.constant = screenWidth * slideshowRatio
        slideshow.transitionDuration = 1
        slideshow.transitionType = .Slide
        slideshow.imagesContentMode = .ScaleAspectFill
        slideshow.addGesture(.Swipe)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedArticle))
        slideshow.addGestureRecognizer(tap)
        slideshow.delegate = self
    }
    
    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.layer.zPosition = 1
    }
    
    private func setupWorkout() {
        workoutImageViewHeight.constant = (screenWidth - 16) * workoutRatio
    }
    
    private func setupVideos() {
        videoThumbnailViews[0].labelBackgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        videoThumbnailViews[1].labelBackgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    }
    
    private func addArticles(json: JSON) {
        for (key, data) in json {
            let article = Article(date: key, data: data.dictionaryObject as! [String:String])
            articles.append(article)
            slideshow.addImage(article.textImage)
            pageControl.numberOfPages = articles.count
        }
    }
    
    private func addVideos(json: JSON) {
        for (key, data) in json {
            let video = Video(id: key, data: data.dictionaryObject!)
            Alamofire.request(.GET, "http://img.youtube.com/vi/\(video.id)/mqdefault.jpg").responseImage(completionHandler: { response in
                if let image = response.result.value {
                    video.image = image
                    let videoThumbnailView = self.videoThumbnailViews[self.videos.count]
                    videoThumbnailView.thumbnailView.image = video.image
                    videoThumbnailView.titleLabel.text = video.title
                    videoThumbnailView.index = self.videos.count
                    
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
        workoutImageView.image = workout!.image
        workoutImageView.workout = workout
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedWorkout(_:)))
        workoutImageView.userInteractionEnabled = true
        workoutImageView.addGestureRecognizer(tap)
    }
    
    private func loadFeatured() {
        FirebaseManager.sharedRootRef.childByAppendingPath("featured").observeSingleEventOfType(.Value, withBlock: { snapshot in
            let featured = JSON(snapshot.value)
            self.addArticles(featured["articles"])
            self.addVideos(featured["videos"])
            self.addWorkout(featured["workout"])
        })
    }
    
    @objc private func nextSlide() {
        slideshow.next()
    }
    
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
        setupWorkout()
        setupVideos()
        loadFeatured()
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(nextSlide), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
