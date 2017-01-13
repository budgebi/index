//
//  Draggable.swift
//  Index
//
//  Created by Brian Budge on 1/12/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

class DraggableIcon: NSObject {
    
    public var view: UIImageView
    public var origin: CGPoint
    public var width: CGFloat
    public var height: CGFloat
    public var image: UIImage
    public var gestureRecognizer: UIPanGestureRecognizer

    init(origin: CGPoint, width: CGFloat, height: CGFloat, image: UIImage, gestureRecognizer: UIPanGestureRecognizer) {
        self.origin = origin
        
        let frame: CGRect = CGRect(x: self.origin.x, y: self.origin.y, width: width, height: height)
        self.view = UIImageView(frame: frame)
        
        self.width = width
        self.height = height
        self.image = image
        
        self.view.image = image
        self.gestureRecognizer = gestureRecognizer
        self.view.addGestureRecognizer(gestureRecognizer)
        super.init()
    }
}
