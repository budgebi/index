//
//  ViewController.swift
//  Index
//
//  Created by Brian Budge on 9/25/16.
//  Copyright © 2016 Brian Budge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var paperView: PaperView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

