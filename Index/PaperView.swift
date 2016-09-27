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
    fileprivate let eraseLineWidth: CGFloat = 20
    fileprivate var lineWidth: CGFloat!
    
    fileprivate let paperColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    fileprivate var drawColor: UIColor = UIColor.black
    
    fileprivate var touch: UITouch!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.isUserInteractionEnabled = true
        self.lineWidth = mediumLineWidth
        
        self.backgroundColor = self.paperColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        image?.draw(in: bounds)
        
        drawPoint(context, touch: touch)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    fileprivate func drawPoint(_ context: CGContext?, touch: UITouch) {
        let previousLocation = touch.location(in: self)
        let location = touch.location(in: self)
        
        drawColor.setStroke()
        
        context?.setLineWidth(self.lineWidth)
        context?.setLineCap(.round)
        
        
        context?.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
        context?.addLine(to: CGPoint(x: location.x, y: location.y))
        
        context?.strokePath()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touch = touches.first
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        image?.draw(in: bounds)
        
        drawStroke(context, touch: touch)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    fileprivate func drawStroke(_ context: CGContext?, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        drawColor.setStroke()
        
        context?.setLineWidth(self.lineWidth)
        context?.setLineCap(.round)
        
        
        context?.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
        context?.addLine(to: CGPoint(x: location.x, y: location.y))

        context?.strokePath()
    }
    
    public func setLineWidth(lWidth: String) {
        self.drawColor = UIColor.black
        if lWidth == "small" {
            self.lineWidth = self.smallLineWidth
        } else if lWidth == "medium" {
            self.lineWidth = self.mediumLineWidth
        } else {
            self.lineWidth = self.largeLineWidth
        }
    }
    
    public func useEraser() {
        // Todo: this actually won't work most likely because the image is clear
        // and we draw on it with the paper color so we aren't really deleting the line.
        // maybe draw on it with clear?
        self.lineWidth = self.eraseLineWidth
        self.drawColor = self.paperColor
    }
    
    public func deleteNote() {
        image = nil
    }
}
