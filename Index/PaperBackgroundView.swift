//
//  PaperBackgroundView.swift
//  Index
//
//  Created by Brian Budge on 10/4/16.
//  Copyright © 2016 Brian Budge. All rights reserved.
//

import UIKit

class PaperBackgroundView: UIImageView {

    fileprivate let blueLineColor: UIColor = UIColor.init(red: 173/255, green: 216/255, blue: 230/255, alpha: 1);
    fileprivate let redLineColor: UIColor = UIColor.init(red: 255/255, green: 102/255, blue: 102/255, alpha: 1);
    
    public func drawGridPaper() {
        self.image = nil
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image?.draw(in: bounds)
        for i in 1...32 {
            let index: CGFloat = CGFloat(i)
            let multiplier: CGFloat = 32
            drawVerticalLines(xLocation: index*multiplier, context: context!, drawColor: blueLineColor)
        }
        for i in 1...62 {
            let index: CGFloat = CGFloat(i)
            let multiplier: CGFloat = 32
            drawHorizontalLines(yLocation: index*multiplier, context: context!, drawColor: blueLineColor)
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    public func drawLinedPaper() {
        self.image = nil
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image?.draw(in: bounds)
        let multiplier: CGFloat = 32

        for i in 2...62 {
            let index: CGFloat = CGFloat(i)
            drawHorizontalLines(yLocation: index*multiplier, context: context!, drawColor: blueLineColor)
        }
        drawVerticalLines(xLocation: CGFloat(3)*multiplier, context: context!, drawColor: redLineColor)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    public func drawPlainPaper() {
        image = nil
    }
        
    fileprivate func drawVerticalLines(xLocation: CGFloat, context: CGContext, drawColor: UIColor) {
        drawColor.setStroke()
        
        context.setLineWidth(1)
        context.setLineCap(.round)
        
        
        context.move(to: CGPoint(x: xLocation, y: 0))
        context.addLine(to: CGPoint(x: xLocation, y: 2000))
            
        context.strokePath()
    
    }
    
    fileprivate func drawHorizontalLines(yLocation: CGFloat, context: CGContext, drawColor: UIColor) {
        drawColor.setStroke()
        
        context.setLineWidth(1)
        context.setLineCap(.round)
        
        
        context.move(to: CGPoint(x: 0, y: yLocation))
        context.addLine(to: CGPoint(x: 1024, y: yLocation))
        
        context.strokePath()
        
    }

}
