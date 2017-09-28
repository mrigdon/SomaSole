//
//  News2ViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/20/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import KASlideShow
//import youtube_ios_player_helper
//import Alamofire

//extension News2ViewController: KASlideShowDelegate {
//    func kaSlideShowDidShowNext(slideShow: KASlideShow!) {
//        pageControl.currentPage = Int(slideshow.currentIndex)
//    }
//    
//    func kaSlideShowDidShowPrevious(slideShow: KASlideShow!) {
//        pageControl.currentPage = Int(slideshow.currentIndex)
//    }
//}

class News2ViewController: UIViewController {
    
    // constants
    let screenWidth = UIScreen.main.bounds.width
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
//    var slideshow = KASlideShow()
    var pageControl = UIPageControl()
    var firstArticleImage = true

    // outlets
    @IBOutlet weak var slideshowView: ContainerView!
    @IBOutlet weak var workoutView: WorkoutContainerView!
    @IBOutlet weak var workoutViewHeight: NSLayoutConstraint!
    @IBOutlet weak var slideshowHeight: NSLayoutConstraint!
    @IBOutlet var videoThumbnailViews: [VideoContainerView]!
    
    // methods
    @objc fileprivate func tappedArticle() {
        performSegue(withIdentifier: "articleSegue", sender: self)
    }
    
    @objc fileprivate func tappedWorkout(_ tap: AnyObject) {
        performSegue(withIdentifier: "workoutSegue", sender: self)
    }
    
    @objc fileprivate func tappedVideoThumbnail(_ tap: UITapGestureRecognizer) {
        let containerView = tap.view as! VideoContainerView
        selectedVideo = containerView.video
        performSegue(withIdentifier: "videoSegue", sender: self)
    }
    
    fileprivate func setupNavbar() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    fileprivate func setupSlideshow() {
        let placeholder = PlaceholderView()
        slideshowView.delegate = placeholder
        slideshowView.subview = placeholder
        
        slideshowHeight.constant = screenWidth * slideshowRatio
//        slideshow.transitionDuration = 1
//        slideshow.transitionType = .Slide
//        slideshow.imagesContentMode = .ScaleAspectFill
//        slideshow.addGesture(.Swipe)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedArticle))
//        slideshow.addGestureRecognizer(tap)
//        slideshow.delegate = self
    }
    
    fileprivate func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.layer.zPosition = 1
    }
    
    fileprivate func setupWorkout() {
        workoutViewHeight.constant = (screenWidth - 16) * workoutRatio
        let placeholder = PlaceholderView()
        workoutView.delegate = placeholder
        workoutView.subview = placeholder
    }
    
    fileprivate func setupVideos() {
        for view in videoThumbnailViews {
            let placeholder = PlaceholderView()
            view.delegate = placeholder
            view.subview = placeholder
        }
    }
    
    fileprivate func addArticles(_ articles: [Article]) {
        for article in articles {
            article.loadTextImage {
//                self.slideshow.addImage(article.textImage)
                self.articles.append(article)
                self.pageControl.numberOfPages = self.articles.count
                if self.firstArticleImage {
                    self.firstArticleImage = false
//                    self.slideshowView.subview = self.slideshow
//                    self.slideshowView.addSubview(self.pageControl)
//                    self.pageControl.snp_makeConstraints(closure: { make in
//                        make.bottom.equalTo(self.slideshowView)
//                        make.centerX.equalTo(self.slideshowView)
//                    })
                    Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.nextSlide), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    fileprivate func addVideos(_ videos: [Video]) {
        for video in videos {
            video.loadImage {
                let videoThumbnailView = self.videoThumbnailViews[self.videos.count]
                let videoView = FeaturedVideoView(image: video.image!, title: video.title, frame: videoThumbnailView.frame, index: self.videos.count)
                videoThumbnailView.subview = videoView
                videoThumbnailView.video = video
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedVideoThumbnail(_:)))
                videoThumbnailView.isUserInteractionEnabled = true
                videoThumbnailView.addGestureRecognizer(tap)
                
                self.videos.append(video)
            }
        }
    }
    
    fileprivate func addWorkout(_ workout: Workout?) {
        self.workout = workout
        if let workout = self.workout {
            workout.loadImage {
                let workoutImageView = UIImageView(image: workout.image)
                workoutImageView.image = workout.image
                self.workoutView.workout = workout
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedWorkout(_:)))
                workoutImageView.isUserInteractionEnabled = true
                workoutImageView.addGestureRecognizer(tap)
                self.workoutView.subview = workoutImageView
            }
        }
    }
    
    fileprivate func loadFeatured() {
        Backend.shared.getFeatured { featured in
            self.addArticles(featured.articles.map { $0 })
            self.addVideos(featured.videos.map { $0 })
            self.addWorkout(featured.workout)
        }
    }
    
    @objc fileprivate func nextSlide() {
//        slideshow.next()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "articleSegue" {
            let destVC = segue.destination as! ArticleViewController
//            destVC.article = articles[Int(slideshow.currentIndex)]
        } else if segue.identifier == "workoutSegue" {
            let destVC = segue.destination as! UINavigationController
            let rootVC = destVC.viewControllers.first as! BeginWorkoutViewController
            rootVC.workout = workout
            rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: rootVC, action: #selector(BeginWorkoutViewController.dismissVC))
        } else if segue.identifier == "videoSegue" {
            let destVC = segue.destination as! UINavigationController
            let rootVC = destVC.viewControllers.first as! PlayVideoViewController
            rootVC.video = selectedVideo
            rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: rootVC, action: #selector(PlayVideoViewController.dismissVC))
        }
    }

}
