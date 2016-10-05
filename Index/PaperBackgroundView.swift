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
    fileprivate let redLineColor: UIColor = UIColor.red;
    
    public func drawGridPaper() {
        self.image = nil
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image?.draw(in: bounds)
        for i in 1...32 {
            let index: CGFloat = CGFloat(i)
            let multiplier: CGFloat = 32
            drawHorizontalLines(xLocation: index*multiplier, context: context!)
        }
        for i in 1...62 {
            let index: CGFloat = CGFloat(i)
            let multiplier: CGFloat = 32
            drawVerticalLines(yLocation: index*multiplier, context: context!)
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
        
    fileprivate func drawHorizontalLines(xLocation: CGFloat, context: CGContext) {
        blueLineColor.setStroke()
        
        context.setLineWidth(1)
        context.setLineCap(.round)
        
        
        context.move(to: CGPoint(x: xLocation, y: 0))
        context.addLine(to: CGPoint(x: xLocation, y: 2000))
            
        context.strokePath()
    
    }
    
    fileprivate func drawVerticalLines(yLocation: CGFloat, context: CGContext) {
        blueLineColor.setStroke()
        
        context.setLineWidth(1)
        context.setLineCap(.round)
        
        
        context.move(to: CGPoint(x: 0, y: yLocation))
        context.addLine(to: CGPoint(x: 1024, y: yLocation))
        
        context.strokePath()
        
    }

}
