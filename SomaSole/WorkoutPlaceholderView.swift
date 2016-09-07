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

extension WorkoutPlaceholderView: QuickStartViewDelegate {
    func didAddToView(view: UIView) {
        let height = 0.3 * view.frame.height
        addSubview(shimmer)
        shimmer.snp_makeConstraints(closure: { make in
            make.height.equalTo(height)
            make.width.equalTo(height)
            make.center.equalTo(self)
        })
    }
}

class WorkoutPlaceholderView: UIView {
    
    private let backgroundColorRatio: CGFloat = 220/255
    private let contentViewColorRatio: CGFloat = 170/255
    
    private let shimmer = FBShimmeringView()
    private let dimension = 50
    private let shimmeringSpeed: CGFloat = 25
    private let shimmeringPauseDuration = 0.005
    private let shimmering = true
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        backgroundColor = UIColor(red: backgroundColorRatio, green: backgroundColorRatio, blue: backgroundColorRatio, alpha: 1.0)
        
        let image = UIImage(named: "exercise")
        let imageView = UIImageView(image: image)
        imageView.image = imageView.image!.imageWithRenderingMode(.AlwaysTemplate)
        imageView.tintColor = UIColor(red: contentViewColorRatio, green: contentViewColorRatio, blue: contentViewColorRatio, alpha: 1.0)
        
        shimmer.contentView = imageView
        shimmer.shimmering = shimmering
        shimmer.shimmeringSpeed = shimmeringSpeed
        shimmer.shimmeringPauseDuration = shimmeringPauseDuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

class WorkoutCellPlaceholderView: WorkoutPlaceholderView {
    
    var size: CGFloat = 0
    
    override func didAddToView(view: UIView) {
        let height = 0.3 * size
        addSubview(shimmer)
        shimmer.snp_makeConstraints(closure: { make in
            make.height.equalTo(height)
            make.width.equalTo(height)
            make.center.equalTo(self)
        })
    }
    
}
