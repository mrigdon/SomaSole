//
//  Extensions.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/12/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

extension UIView {
    func clearSubviews() {
        for v in subviews {
            v.removeFromSuperview()
        }
    }
}
