//
//  NewsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/25/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import KASlideShow

extension UIColor {
    static func somasoleColor() -> UIColor { return UIColor(red: 0.568627451, green: 0.7333333333, blue: 0.968627451, alpha: 1.0) }
}

class NewsViewController: UIViewController, UIScrollViewDelegate, KASlideShowDelegate {
    
    // constants
    let screenWidth = UIScreen.mainScreen().bounds.width

    // outlets
    @IBOutlet weak var slideshow: KASlideShow!
    @IBOutlet weak var slideshowHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var recImageView0: UIImageView!
    @IBOutlet weak var recImageView1: UIImageView!
    @IBOutlet weak var recImageView2: UIImageView!
    @IBOutlet weak var recImageView3: UIImageView!
    
    // methods
    @objc private func tappedArticle() {
        performSegueWithIdentifier("articleSegue", sender: self)
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // white back button
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // init slideshow
        slideshowHeightConstraint.constant = screenWidth
        slideshow.delay = 3
        slideshow.transitionDuration = 1
        slideshow.transitionType = .Slide
        slideshow.imagesContentMode = .ScaleToFill
        
        slideshow.addImage(UIImage(named: "news_test"))
        slideshow.addImage(UIImage(named: "news_test2"))
        slideshow.addImage(UIImage(named: "news_test3"))
        slideshow.addGesture(.Swipe)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedArticle))
        slideshow.addGestureRecognizer(tap)
        slideshow.delegate = self
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.layer.zPosition = 1
        
        // init recommended
        recImageView0.contentMode = .ScaleAspectFill
        recImageView1.contentMode = .ScaleAspectFill
        recImageView2.contentMode = .ScaleAspectFill
        recImageView3.contentMode = .ScaleAspectFill
        recImageView0.image = UIImage(named: "ab_shred")
        recImageView1.image = UIImage(named: "booty_blaster")
        recImageView2.image = UIImage(named: "cool_down")
        recImageView3.image = UIImage(named: "upper_body_blast")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
