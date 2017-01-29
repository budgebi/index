//
//  Link.swift
//  Index
//
//  Created by Brian Budge on 1/25/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import Foundation
import UIKit

class Link: NSObject {
    public var origin: CGPoint!
    public var noteTitle: String!
    public var button: UIButton!
    
    weak var delegate: LinkDelegate?
    
    init(origin: CGPoint, noteTitle: String) {
        super.init()
        self.origin = origin
        self.noteTitle = noteTitle
    
        self.button = UIButton(type: .custom)
        self.button.setTitle(self.noteTitle, for: .normal)
        self.button.setTitleColor(UIColor.blue, for: .normal)
        let buttonSize = (self.noteTitle as NSString).size(attributes: [NSFontAttributeName: self.button.titleLabel?.font ?? UIFont.systemFont(ofSize: 12)])
        self.button.frame = CGRect(origin: self.origin, size: CGSize(width: buttonSize.width, height: buttonSize.height))
        self.button.addTarget(self, action: #selector(loadLink), for: .touchUpInside)
    }
    
    func loadLink() {
        self.delegate?.loadLink(link: self)
    }
}
