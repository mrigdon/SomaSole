//
//  ArticleViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/26/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    // constants
    let screenWidth = UIScreen.mainScreen().bounds.width

    // outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bodyView: UITextView!
    
    // methods
    private func setupImageView() {
        imageViewHeight.constant = screenWidth - 16
    }
    
    private func setupHeadline() {
        headlineLabel.numberOfLines = 0
        headlineLabel.lineBreakMode = .ByWordWrapping
        
        let font = UIFont(name: "GillSans-Light", size: 36)
        headlineLabel.font = font
        headlineLabel.text = "The verdict is in: Android is fair use as Google beats Oracle"
        
        headlineLabel.sizeToFit()
    }
    
    private func setupAuthor() {
        let font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        authorLabel.font = font
        authorLabel.text = "by Joe Mullin"
        authorLabel.sizeToFit()
    }
    
    private func setupTime() {
        let font = UIFont(name: "HelveticaNeue", size: 12)
        timeLabel.font = font
        timeLabel.text = "May 26, 2016 4:03 pm PDT"
        timeLabel.sizeToFit()
    }
    
    private func setupBody() {
        bodyView.editable = true
        
        let font = UIFont(name: "Georgia", size: 20)
        bodyView.font = font
        
        bodyView.editable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        
        setupImageView()
        setupHeadline()
        setupAuthor()
        setupTime()
        setupBody()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
