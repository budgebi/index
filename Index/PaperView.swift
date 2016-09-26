//
//  PaperView.swift
//  Index
//
//  Created by Brian Budge on 9/25/16.
//  Copyright © 2016 Brian Budge. All rights reserved.
//

import UIKit

class PaperView: UIImageView {
    
    fileprivate let smallLineWidth: CGFloat = 2
    fileprivate let mediumLineWidth: CGFloat = 4
    fileprivate let largeLineWidth: CGFloat = 6
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
