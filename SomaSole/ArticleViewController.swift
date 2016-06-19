//
//  ArticleViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/26/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class ArticleViewController: UIViewController {
    
    // constants
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    // variables
    var article: Article?

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
        imageView.image = article!.image
    }
    
    private func setupHeadline() {
        headlineLabel.numberOfLines = 0
        headlineLabel.lineBreakMode = .ByWordWrapping
        
        let font = UIFont(name: "GillSans-Light", size: 36)
        headlineLabel.font = font
        headlineLabel.text = article!.headline
        
        headlineLabel.sizeToFit()
    }
    
    private func setupAuthor() {
        let font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        authorLabel.font = font
        authorLabel.text = "by \(article!.author)"
        authorLabel.sizeToFit()
    }
    
    private func setupTime() {
        let font = UIFont(name: "HelveticaNeue", size: 12)
        timeLabel.font = font
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .FullStyle
        let dateString = formatter.stringFromDate(article!.date)
        
        timeLabel.text = dateString
        timeLabel.sizeToFit()
    }
    
    private func setupBody() {
        bodyView.editable = true
        
        let mdText = SwiftyMarkdown(string: article!.body)
        mdText.body.fontName = "Georgia"
        mdText.body.fontSize = 20
        bodyView.attributedText = mdText.attributedString()
        
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
