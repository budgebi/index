//
//  LinkSearchBar.swift
//  Index
//
//  Created by Brian Budge on 1/17/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

class LinkSearchBar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }

}
