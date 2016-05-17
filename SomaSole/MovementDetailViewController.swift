//
//  MovementDetailViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/16/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AWSS3

class MovementDetailViewController: UIViewController {
    
    // variables
    var movement: Movement?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = movement!.title
//        self.descriptionLabel.text = movement!.movementDescription
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
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
