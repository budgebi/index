//
//  ViewController.swift
//  Index
//
//  Created by Brian Budge on 9/25/16.
//  Copyright © 2016 Brian Budge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var colorOptionsDisplayed = false
    fileprivate var sizeOptionsDisplayed = false
    fileprivate var paperOptionsDisplayed = false
    fileprivate var drawStyleOptionsDisplayed = false
    
    fileprivate let paperColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

    @IBOutlet weak var paperView: PaperView!
    @IBOutlet weak var paperBackground: PaperBackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paperBackground.backgroundColor = paperColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        paperBackground.drawPlainPaper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func deleteNote() {
        self.paperView.deleteNote()
    }
    
    @IBAction func eraserButtonPressed() {
        self.paperView.useEraser()
    }
    
    @IBAction func paperButtonPressed(sender: AnyObject) {
        let paperButton = sender as! UIButton
        paperBackground.setPaper(paper: paperButton.accessibilityIdentifier!)

        if(paperButton.tag != 60) {
            let selectedPaper = self.view.viewWithTag(60) as! UIButton
            let prevImage = selectedPaper.image(for: .normal)
            let prevStyle = selectedPaper.accessibilityIdentifier
            
            let newStyleImage = paperButton.image(for: .normal)
            selectedPaper.setImage(newStyleImage, for: .normal)
            selectedPaper.accessibilityIdentifier = paperButton.accessibilityIdentifier
            
            paperButton.setImage(prevImage, for: .normal)
            paperButton.accessibilityIdentifier = prevStyle
        }
        
        animateOptions(hide: paperOptionsDisplayed, startTag: 60, endTag: 62)
        paperOptionsDisplayed = !paperOptionsDisplayed

    }
    
    @IBAction func drawStyleButtonPressed(sender: AnyObject) {
        let drawStyleButton = sender as! UIButton
        paperView.setDrawStyle(style: drawStyleButton.accessibilityIdentifier!)

        if(drawStyleButton.tag != 1) {
            let selectedStyle = self.view.viewWithTag(1) as! UIButton
            let prevImage = selectedStyle.image(for: .normal)
            let prevStyle = selectedStyle.accessibilityIdentifier
            
            let newStyleImage = drawStyleButton.image(for: .normal)
            selectedStyle.setImage(newStyleImage, for: .normal)
            selectedStyle.accessibilityIdentifier = drawStyleButton.accessibilityIdentifier
            
            drawStyleButton.setImage(prevImage, for: .normal)
            drawStyleButton.accessibilityIdentifier = prevStyle
        }
        
        animateOptions(hide: drawStyleOptionsDisplayed, startTag: 1, endTag: 2)
        drawStyleOptionsDisplayed = !drawStyleOptionsDisplayed
    }
    
    @IBAction func sizeButtonPressed(sender: AnyObject) {
        let sizeButton = sender as! UIButton
        paperView.setLineWidth(lWidth: sizeButton.accessibilityIdentifier!)

        if(sizeButton.tag != 20) {
            let selectedSize = self.view.viewWithTag(20) as! UIButton
            let prevImage = selectedSize.image(for: .normal)
            let prevSize = selectedSize.accessibilityIdentifier
            
            let newSizeImage = sizeButton.image(for: .normal)
            selectedSize.setImage(newSizeImage, for: .normal)
            selectedSize.accessibilityIdentifier = sizeButton.accessibilityIdentifier
            
            sizeButton.setImage(prevImage, for: .normal)
            sizeButton.accessibilityIdentifier = prevSize
        }
        animateOptions(hide: sizeOptionsDisplayed, startTag: 20, endTag: 22)
        sizeOptionsDisplayed = !sizeOptionsDisplayed

    }
    
    @IBAction func colorCommand(sender: AnyObject) {
        let colorButton = sender as! UIButton
        paperView.setDrawColor(color: colorButton.accessibilityIdentifier!)

        if(colorButton.tag != 10) {
            let selectedColor = self.view.viewWithTag(10) as! UIButton
            let prevImage = selectedColor.image(for: .normal)
            let prevColor = selectedColor.accessibilityIdentifier
            
            let newColorImage = colorButton.image(for: .normal)
            selectedColor.setImage(newColorImage, for: .normal)
            selectedColor.accessibilityIdentifier = colorButton.accessibilityIdentifier
            
            colorButton.setImage(prevImage, for: .normal)
            colorButton.accessibilityIdentifier = prevColor
        }
        
        animateOptions(hide: colorOptionsDisplayed, startTag: 10, endTag: 14)
        colorOptionsDisplayed = !colorOptionsDisplayed
    }
    
    @IBAction func undoButtonPressed() {
        self.paperView.undo()
    }
    
    func animateOptions(hide: Bool, startTag: Int, endTag: Int) {
        let start: CGFloat!
        let end: CGFloat!
        let tagInc: Int!
        var beginTag: Int!
        if hide == true {
            start = 1
            end = 0
            tagInc = -1
            beginTag = endTag + 1
            
        } else {
            start = 0
            end = 1
            tagInc = 1
            beginTag = startTag
        }
        
        let steps = endTag - startTag
        
        let delay: TimeInterval = 0.0
        let duration: TimeInterval = Double(steps+1) * 0.05
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: .calculationModeLinear, animations: {
            
            for i in 1...steps {
                beginTag = beginTag + tagInc
                let colorOption = self.view.viewWithTag(beginTag) as! UIButton
                colorOption.alpha = start

                UIView.addKeyframe(withRelativeStartTime: Double(i)/Double(steps+1), relativeDuration: Double(1)/Double(steps+1), animations: {
                    colorOption.isEnabled = true
                    colorOption.isHidden = false
                    colorOption.alpha = end
                })
            }
            
            }, completion: {finished in
        })
    }
}

