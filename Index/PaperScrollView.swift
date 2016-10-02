//
//  PaperScrollView.swift
//  Index
//
//  Created by Brian Budge on 10/2/16.
//  Copyright © 2016 Brian Budge. All rights reserved.
//

import UIKit

class PaperScrollView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        panGestureRecognizer.minimumNumberOfTouches = 2;
        panGestureRecognizer.maximumNumberOfTouches = 2;
        panGestureRecognizer.delaysTouchesBegan = false;
        panGestureRecognizer.delaysTouchesEnded = false;
        self.delaysContentTouches = false;
    }
}
