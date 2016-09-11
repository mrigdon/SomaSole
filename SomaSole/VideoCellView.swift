//
//  VideoCellView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/11/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import EPShapes

class VideoCellView: UIView {
    
    var star = UIButton()
    var label = UILabel()
    var imageView = UIImageView()

    init() {
        super.init(frame: CGRectZero)
        
        star.setImage(UIImage(named: "star_unfilled"), forState: .Normal)
        addSubviewWithConstraints(star, height: 30, width: 30, top: 8, left: nil, right: 8, bottom: nil)
        
        addSubview(label)
        label.snp_makeConstraints(closure: { make in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(8)
            make.right.equalTo(star.snp_left).offset(8)
        })
        
        addSubview(imageView)
        imageView.snp_makeConstraints(closure: { make in
            make.top.equalTo(label.snp_bottom).offset(12)
            make.left.equalTo(self.snp_leftMargin)
            make.right.equalTo(self.snp_rightMargin)
            make.bottom.equalTo(self).offset(-10)
            make.height.equalTo((UIScreen.mainScreen().bounds.width - 16) * (9/16))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
