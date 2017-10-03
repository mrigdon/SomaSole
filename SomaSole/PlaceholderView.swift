//
//  PlaceholderView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/1/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
//import Shimmer
import SnapKit

extension PlaceholderView: ContainerViewDelegate {
    @objc func didAddToView(_ view: UIView) {
        let height = 0.3 * view.frame.height
//        addSubview(shimmer)
//        shimmer.snp.makeConstraints { make in
//            make.height.equalTo(height)
//            make.width.equalTo(height)
//            make.center.equalTo(self)
//        }
    }
}

class PlaceholderView: UIView {
    
    fileprivate let backgroundColorRatio: CGFloat = 220/255
    fileprivate let contentViewColorRatio: CGFloat = 170/255
    
//    private let shimmer = FBShimmeringView()
    fileprivate let dimension = 50
    fileprivate let shimmeringSpeed: CGFloat = 25
    fileprivate let shimmeringPauseDuration = 0.005
    fileprivate let shimmering = true
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        backgroundColor = UIColor(red: backgroundColorRatio, green: backgroundColorRatio, blue: backgroundColorRatio, alpha: 1.0)
        
        let image = UIImage(named: "exercise")
        let imageView = UIImageView(image: image)
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: contentViewColorRatio, green: contentViewColorRatio, blue: contentViewColorRatio, alpha: 1.0)
        
//        shimmer.contentView = imageView
//        shimmer.shimmering = shimmering
//        shimmer.shimmeringSpeed = shimmeringSpeed
//        shimmer.shimmeringPauseDuration = shimmeringPauseDuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

class WorkoutCellPlaceholderView: PlaceholderView {
    
    var size: CGFloat = 0
    
    override func didAddToView(_ view: UIView) {
        let height = 0.3 * size
//        addSubview(shimmer)
//        shimmer.snp.makeConstraints { make in
//            make.height.equalTo(height)
//            make.width.equalTo(height)
//            make.center.equalTo(self)
//        }
    }
    
}

class VideoCellPlaceholderView: PlaceholderView {
    
    var size: CGFloat = 0
    
    override func didAddToView(_ view: UIView) {
        let height = 0.3 * size
//        addSubview(shimmer)
//        shimmer.snp.makeConstraints { make in
//            make.height.equalTo(height)
//            make.width.equalTo(height)
//            make.center.equalTo(self)
//        }
    }
    
}
