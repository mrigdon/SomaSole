//
//  VideoCellView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/11/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import EPShapes

class VideoCellView: UIView {
    
//    var star = IndexedStar<Video>()
    var label = UILabel()
    var imageView = UIImageView()
    var play = UIImageView()
    
    var video: Video? {
        didSet {
            if let video = video {
                label.text = video.title
                imageView.image = video.image
//                star.data = video
//                star.active = video.favorite
            }
        }
    }

    init() {
        super.init(frame: CGRect.zero)
        
        // star
//        addSubviewWithConstraints(star, height: 30, width: 30, top: 8, left: nil, right: 8, bottom: nil)
        
        // label
        label.font = UIFont(name: "AvenirNext-Regular", size: 20)
        label.numberOfLines = 0
        label.sizeToFit()
        addSubview(label)
//        label.snp_makeConstraints(closure: { make in
//            make.top.equalTo(self).offset(8)
//            make.left.equalTo(self).offset(8)
//            make.right.equalTo(star.snp_left).offset(8)
//        })
        
        // image
        addSubview(imageView)
//        imageView.snp_makeConstraints(closure: { make in
//            make.top.equalTo(label.snp_bottom).offset(16)
//            make.left.equalTo(self.snp_leftMargin)
//            make.right.equalTo(self.snp_rightMargin)
//            make.bottom.equalTo(self).offset(-32)
//            make.height.equalTo((UIScreen.mainScreen().bounds.width - 16) * (9/16))
//        })
        
        // play button
        play.image = UIImage(named: "play")
        imageView.addSubviewWithConstraints(play, height: 40, width: 40, top: 4, left: nil, right: 4, bottom: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
