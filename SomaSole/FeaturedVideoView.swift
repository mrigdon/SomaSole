//
//  FeaturedVideoView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/6/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import SnapKit

class FeaturedVideoView: UIView {
    
    var index = 0

    init(image: UIImage, title: String, frame: CGRect, index: Int) {
        super.init(frame: frame)
        self.index = index
        
        // add background image
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        // add bottom black title view
        let titleView = UIView()
        titleView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        // add title label
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = title
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView).offset(8)
            make.left.equalTo(titleView).offset(8)
            make.right.equalTo(titleView).offset(-8)
            make.bottom.equalTo(titleView).offset(-8)
        }
        
        // add play icon
        let playIcon = UIImageView(image: UIImage(named: "play"))
        self.addSubview(playIcon)
        playIcon.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.top.equalTo(self).offset(3)
            make.right.equalTo(self).offset(-3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
