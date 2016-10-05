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
    fileprivate var previousLineWidth: CGFloat?
    
    fileprivate let paperColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    fileprivate var drawColor: UIColor = UIColor.black
    
    fileprivate let redColor = UIColor(red: 239/255, green: 83/255, blue: 80/255, alpha: 1)
    fileprivate let blueColor = UIColor(red: 66/255, green: 165/255, blue: 245/255, alpha: 1)
    fileprivate let greenColor = UIColor(red: 102/255, green: 187/255, blue: 106/255, alpha: 1)
    fileprivate let yellowColor = UIColor(red: 255/255, green: 202/255, blue: 40/255, alpha: 1)
    fileprivate let blackColor = UIColor.black
    
    fileprivate var lastTouch: UITouch!
    fileprivate var firstTouchLocation: CGPoint!
    
    fileprivate var originalImage: UIImage?
    
    fileprivate var line: Bool!
    
    fileprivate var maxY: CGFloat?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.isUserInteractionEnabled = true
        
        self.lineWidth = mediumLineWidth
        self.line = false
        
        self.backgroundColor = UIColor.clear
        
        self.maxY = 0
    }
    
    // Touches Began - Draw Point
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.firstTouchLocation = touches.first?.location(in: self)
        self.originalImage = image
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        image?.draw(in: bounds)
        
        drawPoint(context, touchLocation: self.firstTouchLocation)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    fileprivate func drawPoint(_ context: CGContext?, touchLocation: CGPoint) {
        
        drawColor.setStroke()
        
        context?.setLineWidth(self.lineWidth)
        context?.setLineCap(.round)
        
        
        context?.move(to: CGPoint(x: touchLocation.x, y: touchLocation.y))
        context?.addLine(to: CGPoint(x: touchLocation.x, y: touchLocation.y))
        
        context?.strokePath()
    }
    
    // Touches Moved - Draw Stroke or Line
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastTouch = touches.first

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        if self.line == false {
            image?.draw(in: bounds)
        
            drawStroke(context, touch: self.lastTouch)
        } else {
            self.originalImage?.draw(in: bounds)
            
            drawLine(context, touch: self.lastTouch)
        }
        
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    fileprivate func drawLine(_ context: CGContext?, touch: UITouch) {
        let previousLocation = self.firstTouchLocation!
        
        let location = touch.location(in: self)
        
        drawColor.setStroke()
        
        context?.setLineWidth(self.lineWidth)
        context?.setLineCap(.round)
        
        
        context?.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
        context?.addLine(to: CGPoint(x: location.x, y: location.y))
        
        context?.strokePath()
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
    
    // Undo and Delete
    public func undo() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        self.originalImage?.draw(in: bounds)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        paperColor.setStroke()
        
        context?.setLineWidth(self.lineWidth)
        context?.setLineCap(.round)
        
        
        context?.move(to: CGPoint(x: firstTouchLocation.x, y: firstTouchLocation.y))
        context?.addLine(to: CGPoint(x: firstTouchLocation.x, y: firstTouchLocation.y))
        
        context?.strokePath()
        
        UIGraphicsEndImageContext()
    }
    
    public func deleteNote() {
        image = nil
    }
    
    // Setters from View Controller
    public func setLineWidth(lWidth: String) {
        self.drawColor = UIColor.black
        if lWidth == "small" {
            self.lineWidth = self.smallLineWidth
        } else if lWidth == "medium" {
            self.lineWidth = self.mediumLineWidth
        } else {
            self.lineWidth = self.largeLineWidth
        }
        self.previousLineWidth = self.lineWidth
    }
    
    public func lineSelected(_ selected: Bool) {
        self.line = selected
    }
    
    public func useEraser() {
        // Todo: this actually won't work most likely because the image is clear
        // and we draw on it with the paper color so we aren't really deleting the line.
        // maybe draw on it with clear?
        if (self.previousLineWidth == nil || self.lineWidth != self.eraseLineWidth) {
            self.previousLineWidth = self.lineWidth
        }
        self.line = false
        self.lineWidth = self.eraseLineWidth
        self.drawColor = self.paperColor
    }
    
    
    public func setDrawColor(color: String) {
        if (self.previousLineWidth != nil) {
            self.lineWidth = self.previousLineWidth
        }
        if color == "red" {
            self.drawColor = self.redColor
        } else if color == "green" {
            self.drawColor = self.greenColor
        } else if color == "blue" {
            self.drawColor = self.blueColor
        } else if color == "yellow" {
            self.drawColor = self.yellowColor
        } else if color == "black" {
            self.drawColor = self.blackColor
        }
    }
}
