//
//  IndexedStarButton.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/11/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import EPShapes

class IndexedStarButton: StarButton {
    
    var index: Int?
    
    init() {
        super.init(frame: CGRectZero)
        
        // set properties
//        fillColor = UIColor.goldColor()
        corners = 5
        extrusionPercent = 50
        strokeColor = UIColor.goldColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

protocol IndexedStarDelegate {
    func didTapStar<T>(star: IndexedStar<T>)
}

class IndexedStar<T>: UIButton {
    
    var data: T?
    var delegate: IndexedStarDelegate?
    var active = false {
        didSet {
            setImage(active ? filled : unfilled, forState: .Normal)
        }
    }
    
    private var unfilled = UIImage(named: "star_unfilled")?.imageWithRenderingMode(.AlwaysTemplate)
    private var filled = UIImage(named: "star_filled")?.imageWithRenderingMode(.AlwaysTemplate)
    
    func tapped() {
        active = !active
        setImage(active ? filled : unfilled, forState: .Normal)
        delegate?.didTapStar(self)
    }
    
    init(active: Bool) {
        super.init(frame: CGRectZero)
        
        self.active = active
        
        tintColor = UIColor.goldColor()
        setImage(active ? filled : unfilled, forState: .Normal)
        
        addTarget(self, action: #selector(tapped), forControlEvents: .TouchUpInside)
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        tintColor = UIColor.goldColor()
        setImage(unfilled, forState: .Normal)
        
        addTarget(self, action: #selector(tapped), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
