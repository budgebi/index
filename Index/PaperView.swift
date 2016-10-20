//
//  PaperView.swift
//  Index
//
//  Created by Brian Budge on 9/25/16.
//  Copyright © 2016 Brian Budge. All rights reserved.
//

import UIKit

class PaperView: UIImageView {
    
    // Line widths
    fileprivate let smallLineWidth: CGFloat = 1
    fileprivate let mediumLineWidth: CGFloat = 4
    fileprivate let largeLineWidth: CGFloat = 6
    fileprivate let eraseLineWidth: CGFloat = 20
    fileprivate let hugeEraserLineWidth: CGFloat = 40
    
    fileprivate var lineWidth: CGFloat!
    fileprivate var previousLineWidth: CGFloat?
    
    // Colors
    fileprivate let paperColor: UIColor = UIColor.clear
    fileprivate var drawColor: UIColor = UIColor.black
    fileprivate var previousDrawColor: UIColor?
    
    fileprivate let redColor = UIColor(red: 239/255, green: 83/255, blue: 80/255, alpha: 1)
    fileprivate let blueColor = UIColor(red: 66/255, green: 165/255, blue: 245/255, alpha: 1)
    fileprivate let greenColor = UIColor(red: 102/255, green: 187/255, blue: 106/255, alpha: 1)
    fileprivate let yellowColor = UIColor(red: 255/255, green: 202/255, blue: 40/255, alpha: 1)
    fileprivate let blackColor = UIColor.black
    
    fileprivate var drawLayer: CAShapeLayer?
    fileprivate var points: [CGPoint]?
    fileprivate var drawPath: UIBezierPath?
    
    // Draw style
    fileprivate var line: Bool!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.isUserInteractionEnabled = true
        
        self.lineWidth = smallLineWidth
        self.line = false
        
        self.previousDrawColor = blackColor
        self.previousLineWidth = smallLineWidth
        
        self.backgroundColor = UIColor.clear
        
        addDrawLayer()
    }
    
    func addDrawLayer() {
        
        drawLayer = CAShapeLayer()
        drawLayer?.frame = layer.bounds
        drawLayer?.lineCap = kCALineCapRound
        drawLayer?.lineJoin = kCALineJoinRound
        drawLayer?.fillColor = UIColor.clear.cgColor
        drawLayer?.backgroundColor = UIColor.clear.cgColor
        drawLayer?.lineWidth = lineWidth
        drawLayer?.strokeColor = drawColor.cgColor
        
        layer.addSublayer(drawLayer!)
        
    }
    
    // Handle Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        points = [(touches.first?.location(in: self))!]
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if let coalescedTouches = event?.coalescedTouches(for: touch!) {
            points? += coalescedTouches.map { $0.preciseLocation(in: self) }
        } else {
            points?.append((touch?.preciseLocation(in: self))!)
        }

        drawPath = UIBezierPath()
        drawPath?.move(to: (points?.first)!)
        for point in points! {
            drawPath?.addLine(to: point)
        }
        
        drawLayer?.path = drawPath?.cgPath
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        image?.draw(in: self.bounds)
        
        drawColor.setStroke()
        drawPath?.lineJoinStyle = .round
        drawPath?.lineCapStyle = .round
        drawPath?.lineWidth = lineWidth
        
        drawPath?.stroke()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        drawLayer?.removeFromSuperlayer()
        addDrawLayer()
    }
    
    // Handle Drawing
    fileprivate func drawPoint(_ context: CGContext?, touch: UITouch) {
    }
    
    fileprivate func drawLine(_ context: CGContext?, touch: UITouch) {
    }
    
    fileprivate func drawStroke(_ context: CGContext?, touch: UITouch) {
    }
    
    // Undo and Delete
    public func undo() {
    }
    
    public func deleteNote() {
        drawLayer?.removeFromSuperlayer()
        addDrawLayer()
        image = nil
    }
    
    // Setters from View Controller
    public func setLineWidth(lWidth: String) {
        self.drawColor = self.previousDrawColor!
        drawLayer?.strokeColor = drawColor.cgColor
        if lWidth == "small" {
            self.lineWidth = self.smallLineWidth
        } else if lWidth == "medium" {
            self.lineWidth = self.mediumLineWidth
        } else {
            self.lineWidth = self.largeLineWidth
        }
        self.previousLineWidth = self.lineWidth
        drawLayer?.lineWidth = lineWidth
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
            drawLayer?.lineWidth = lineWidth
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
        self.previousDrawColor = drawColor
        drawLayer?.strokeColor = drawColor.cgColor
    }
}
