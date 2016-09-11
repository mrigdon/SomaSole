//
//  VideoCellView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/11/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class VideoCellView: UIView {
    
    var label = UILabel()
    var imageView = UIImageView()

    init() {
        super.init(frame: CGRectZero)
        
        addSubviewWithConstraints(label, height: nil, width: nil, top: 8, left: 8, right: 8, bottom: nil)
        
        addSubview(imageView)
        imageView.snp_makeConstraints(closure: { make in
            make.top.equalTo(label.snp_bottom).offset(8)
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
