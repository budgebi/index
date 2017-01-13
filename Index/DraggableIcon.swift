//
//  Draggable.swift
//  Index
//
//  Created by Brian Budge on 1/12/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

class DraggableIcon: NSObject {
    
    public var view: UIButton
    public var origin: CGPoint
    public var width: CGFloat
    public var height: CGFloat
    public var icon: UIImage
    public var gestureRecognizer: UIPanGestureRecognizer

    init(origin: CGPoint, width: CGFloat, height: CGFloat, icon: UIImage, gestureRecognizer: UIPanGestureRecognizer) {
        self.origin = origin
        
        let frame: CGRect = CGRect(x: self.origin.x, y: self.origin.y, width: width, height: height)
        self.view = UIButton(frame: frame)
        self.view.isUserInteractionEnabled = true
        
        self.width = width
        self.height = height
        self.icon = icon
        
        self.view.setImage(icon, for: .normal)
        self.gestureRecognizer = gestureRecognizer
        self.view.addGestureRecognizer(gestureRecognizer)
        super.init()
    }
}
