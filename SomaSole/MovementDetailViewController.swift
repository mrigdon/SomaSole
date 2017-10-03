//
//  MovementDetailViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/16/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import FLAnimatedImage

class MovementDetailViewController: UIViewController {
    
    // constants
    let descriptionFont = UIFont(name: "Helvetica Neue", size: 17.0)
    
    // variables
    var movement: Movement?
    var url: URL?
    var data = Data()
//    var image = FLAnimatedImage()

    // outlets
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    // methods
    fileprivate func ui(_ closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: {
            closure()
        })
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = movement!.title
        self.descriptionLabel.text = movement!.deskription
        self.descriptionLabel.isEditable = true
        self.descriptionLabel.font = descriptionFont
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.isEditable = false
        navigationController!.navigationBar.tintColor = UIColor.black
        startProgressHud()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        url = URL(fileURLWithPath: Bundle.main.path(forResource: "\(movement!.title).gif", ofType: nil)!)
        if let url = url {
            data = try! Data(contentsOf: url)
            //        image = FLAnimatedImage(animatedGIFData: data)
            ui {
                //            self.imageView.animatedImage = self.image
            }
        }
        stopProgressHud()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        imageView.stopAnimating()
        super.viewWillDisappear(animated)
    }

}
