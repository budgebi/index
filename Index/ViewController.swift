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

        animateOptionSlide(button: paperButton, start: 60, end: 62, hide: paperOptionsDisplayed)
        paperOptionsDisplayed = !paperOptionsDisplayed
    }
    
    @IBAction func drawStyleButtonPressed(sender: AnyObject) {
        let drawStyleButton = sender as! UIButton
        paperView.setDrawStyle(style: drawStyleButton.accessibilityIdentifier!)

        animateOptionSlide(button: drawStyleButton, start: 1, end: 2, hide: drawStyleOptionsDisplayed)
        drawStyleOptionsDisplayed = !drawStyleOptionsDisplayed
    }
    
    @IBAction func sizeButtonPressed(sender: AnyObject) {
        let sizeButton = sender as! UIButton
        paperView.setLineWidth(lWidth: sizeButton.accessibilityIdentifier!)

        animateOptionSlide(button: sizeButton, start: 20, end: 22, hide: sizeOptionsDisplayed)
        sizeOptionsDisplayed = !sizeOptionsDisplayed
    }
    
    @IBAction func colorCommand(sender: AnyObject) {
        let colorButton = sender as! UIButton
        paperView.setDrawColor(color: colorButton.accessibilityIdentifier!)
        
        animateOptionSlide(button: colorButton, start: 10, end: 14, hide: colorOptionsDisplayed)
        colorOptionsDisplayed = !colorOptionsDisplayed
    }
    
    @IBAction func undoButtonPressed() {
        self.paperView.undo()
    }
    
    func animateOptionSlide(button: UIButton, start: Int, end: Int, hide: Bool) {
        if(button.tag != start) {
            let selectedOption = self.view.viewWithTag(start) as! UIButton
            let prevImage = selectedOption.image(for: .normal)
            let prevIdentifier = selectedOption.accessibilityIdentifier
            
            let newImage = button.image(for: .normal)
            selectedOption.setImage(newImage, for: .normal)
            selectedOption.accessibilityIdentifier = button.accessibilityIdentifier
            
            button.setImage(prevImage, for: .normal)
            button.accessibilityIdentifier = prevIdentifier
        }
        
        animateOptions(hide: hide, startTag: start, endTag: end)
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

