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
    public var note: Note!
    public var button: UIButton!
    public var index: Int!
    
    weak var delegate: LinkDelegate?
    
    init(origin: CGPoint, note: Note, index: Int) {
        super.init()
        self.origin = origin
        self.note = note
        self.index = index
    
        self.button = UIButton(type: .custom)
        let linkImage = UIImage(named: "Link-Set")
        self.button.setImage(linkImage, for: .normal)
        self.button.frame = CGRect(origin: self.origin, size: CGSize(width: 33, height: 33))
        self.button.addTarget(self, action: #selector(loadLink), for: .touchUpInside)
    }
    
    func loadLink() {
        self.delegate?.loadLink(index: self.index)
    }
}
