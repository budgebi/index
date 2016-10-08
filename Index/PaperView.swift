//
//  PaperView.swift
//  Index
//
//  Created by Brian Budge on 9/25/16.
//  Copyright © 2016 Brian Budge. All rights reserved.
//

import UIKit

class PaperView: UIImageView {
    
    fileprivate let smallLineWidth: CGFloat = 1
    fileprivate let mediumLineWidth: CGFloat = 4
    fileprivate let largeLineWidth: CGFloat = 6
    fileprivate let eraseLineWidth: CGFloat = 20
    fileprivate let hugeEraserLineWidth: CGFloat = 40
    
    fileprivate var lineWidth: CGFloat!
    fileprivate var previousLineWidth: CGFloat?
    
    fileprivate let paperColor: UIColor = UIColor.clear
    fileprivate var drawColor: UIColor = UIColor.black
    fileprivate var previousDrawColor: UIColor?
    
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
        
        self.lineWidth = smallLineWidth
        self.line = false
        
        self.previousDrawColor = blackColor
        self.previousLineWidth = smallLineWidth
        
        self.backgroundColor = UIColor.clear
        
        self.maxY = 0
    }
    
    // Touches Began - Draw Point
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.firstTouchLocation = touches.first?.preciseLocation(in: self)
        self.originalImage = image
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        image?.draw(in: bounds)
        
        drawPoint(context, touch: touches.first!)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    fileprivate func drawPoint(_ context: CGContext?, touch: UITouch) {
        
        if touch.type != .stylus {
            self.lineWidth = hugeEraserLineWidth
            context!.setBlendMode(.clear)
        } else if drawColor == UIColor.clear {
            context!.setBlendMode(.clear)
        } else {
            self.lineWidth = self.previousLineWidth
            context!.setBlendMode(.color)
        }
        
        drawColor.setStroke()
        
        context?.setLineWidth(self.lineWidth)
        context?.setLineCap(.round)
        
        let touchLocation = touch.preciseLocation(in: self)
        context?.move(to: CGPoint(x: touchLocation.x, y: touchLocation.y))
        context?.addLine(to: CGPoint(x: touchLocation.x, y: touchLocation.y))
        
        context?.strokePath()
    }
    
    // Touches Moved - Draw Stroke or Line
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard (touches.first != nil), (event != nil) else
        {
            return
        }
        
        self.lastTouch = touches.first

        var touches = [UITouch]()

        if let coalescedTouches = event?.coalescedTouches(for: self.lastTouch) {
            touches = coalescedTouches
        } else {
            touches.append(self.lastTouch)
        }
        
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        if self.line == false {
            image?.draw(in: bounds)
            for touch in touches {
                drawStroke(context, touch: touch)
            }
        } else {
            self.originalImage?.draw(in: bounds)
            
            drawLine(context, touch: self.lastTouch)
        }
        
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    fileprivate func drawLine(_ context: CGContext?, touch: UITouch) {
        let previousLocation = self.firstTouchLocation!
        
        let location = touch.preciseLocation(in: self)
        
        drawColor.setStroke()
        
        context?.setLineWidth(self.lineWidth)
        context?.setLineCap(.round)
        
        
        context?.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
        context?.addLine(to: CGPoint(x: location.x, y: location.y))
        
        context?.strokePath()
    }
    
    fileprivate func drawStroke(_ context: CGContext?, touch: UITouch) {
        let previousLocation = touch.precisePreviousLocation(in: self)
       
        let location = touch.preciseLocation(in: self)
        
        if touch.type != .stylus {
            self.lineWidth = hugeEraserLineWidth
            context!.setBlendMode(.clear)
        } else if drawColor == UIColor.clear {
            context!.setBlendMode(.clear)
        } else {
            self.lineWidth = self.previousLineWidth
            context!.setBlendMode(.color)
        }
        
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
        self.drawColor = self.previousDrawColor!
        if lWidth == "small" {
            self.lineWidth = self.smallLineWidth
        } else if lWidth == "medium" {
            self.lineWidth = self.mediumLineWidth
        } else {
            self.lineWidth = self.largeLineWidth
        }
        self.previousLineWidth = self.lineWidth
    }
    
    public func setDrawStyle(style: String) {
        self.line = (style == "line")
    }
    
    public func useEraser() {
        // Todo: this actually won't work most likely because the image is clear
        // and we draw on it with the paper color so we aren't really deleting the line.
        // maybe draw on it with clear?
        if (self.previousLineWidth == nil || self.lineWidth != self.eraseLineWidth) {
            self.previousLineWidth = self.lineWidth
        }
        
        if (self.previousDrawColor == nil || self.drawColor != UIColor.clear) {
            self.previousDrawColor = self.drawColor
        }
        
        self.line = false
        self.lineWidth = self.eraseLineWidth
        self.drawColor = UIColor.clear
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
