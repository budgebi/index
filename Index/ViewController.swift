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
    fileprivate let paperColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

    @IBOutlet weak var paperView: PaperView!
    @IBOutlet weak var paperBackground: PaperBackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paperBackground.backgroundColor = paperColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        paperBackground.drawGridPaper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func smallButtonPressed() {
        self.paperView.setLineWidth(lWidth: "small")
    }
    
    @IBAction func mediumButtonPressed() {
        self.paperView.setLineWidth(lWidth: "medium")
    }
    
    @IBAction func largeButtonPressed() {
        self.paperView.setLineWidth(lWidth: "large")
    }
    
    @IBAction func deleteNote() {
        self.paperView.deleteNote()
    }
    
    @IBAction func eraserButtonPressed() {
        self.paperView.useEraser()
    }
    
    @IBAction func drawLine() {
        self.paperView.lineSelected(true)
    }
    
    @IBAction func freeDraw() {
        self.paperView.lineSelected(false)
    }
    
    @IBAction func colorCommand(sender: AnyObject) {
        let colorButton = sender as! UIButton
        if(colorButton.tag != 10) {
            let selectedColor = self.view.viewWithTag(10) as! UIButton
            let prevImage = selectedColor.image(for: .normal)
            let prevColor = selectedColor.accessibilityIdentifier
            
            let newColorImage = colorButton.image(for: .normal)
            selectedColor.setImage(newColorImage, for: .normal)
            selectedColor.accessibilityIdentifier = colorButton.accessibilityIdentifier
            
            paperView.setDrawColor(color: colorButton.accessibilityIdentifier!)
            
            colorButton.setImage(prevImage, for: .normal)
            colorButton.accessibilityIdentifier = prevColor
        }
        animateColorOptions(hide: colorOptionsDisplayed)
        colorOptionsDisplayed = !colorOptionsDisplayed
    }
    
    @IBAction func undoButtonPressed() {
        self.paperView.undo()
    }
    
    func animateColorOptions(hide: Bool) {
        let start: CGFloat!
        let end: CGFloat!
        let tagInc: Int!
        var beginTag: Int!
        if hide == true {
            start = 1
            end = 0
            tagInc = -1
            beginTag = 15
            
        } else {
            start = 0
            end = 1
            tagInc = 1
            beginTag = 10
        }
        
        beginTag = beginTag + tagInc
        var colorOption = self.view.viewWithTag(beginTag) as! UIButton
        colorOption.alpha = start
        
        let delay: TimeInterval = 0.01
        let duration: TimeInterval = 0.01
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
            colorOption.isEnabled = true
            colorOption.isHidden = false
            colorOption.alpha = end
            }, completion: { finished in
                beginTag = beginTag + tagInc
                colorOption = self.view.viewWithTag(beginTag) as! UIButton
                colorOption.alpha = start
                UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                    colorOption.isEnabled = true
                    colorOption.isHidden = false
                    colorOption.alpha = end
                    }, completion: { finished in
                        beginTag = beginTag + tagInc
                        colorOption = self.view.viewWithTag(beginTag) as! UIButton
                        colorOption.alpha = start
                        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                            colorOption.isEnabled = true
                            colorOption.isHidden = false
                            colorOption.alpha = end
                            }, completion: { finished in
                                beginTag = beginTag + tagInc
                                colorOption = self.view.viewWithTag(beginTag) as! UIButton
                                colorOption.alpha = start
                                UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                                    colorOption.isEnabled = true
                                    colorOption.isHidden = false
                                    colorOption.alpha = end
                                    }, completion: nil
                                )
                            }
                        )
                    }
                )
            }
        )
    }
}

