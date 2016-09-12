//
//  NewVideoCell.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/12/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class NewVideoCell: UITableViewCell {

    var videoView: VideoCellView? {
        didSet {
            if let videoView = videoView {
                contentView.addSubviewWithConstraints(videoView, height: nil, width: nil, top: 0, left: 0, right: 0, bottom: 0)
            }
        }
    }

}
