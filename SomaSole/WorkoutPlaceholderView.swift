//
//  WorkoutPlaceholderView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/1/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Shimmer
import SnapKit

class WorkoutPlaceholderView: UIView {
    
    private let shimmer = FBShimmeringView()
    private let dimension = 50
    private let shimmeringSpeed: CGFloat = 25
    private let shimmeringPauseDuration = 0.005
    private let shimmering = true
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.addSubview(shimmer)
        shimmer.snp_makeConstraints(closure: { make in
            make.height.equalTo(dimension)
            make.width.equalTo(dimension)
            make.center.equalTo(self)
        })
        let image = UIImage(named: "exercise")
        let imageView = UIImageView(image: image)
        shimmer.contentView = imageView
        shimmer.shimmering = shimmering
        shimmer.shimmeringSpeed = shimmeringSpeed
        shimmer.shimmeringPauseDuration = shimmeringPauseDuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
