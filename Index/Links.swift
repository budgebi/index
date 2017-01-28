//
//  Links.swift
//  Index
//
//  Created by Brian Budge on 1/28/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

class Links: NSObject {
    
    public var links = [Link]()
    
    init(links: [Link]) {
        super.init()
        self.links = links
    }
    
    init(string: String, linkDelegate: LinkDelegate) {
        super.init()
        self.links = self.deStringify(string, linkDelegate: linkDelegate)
    }
    
    public func add(_ link: Link) {
        links.append(link)
    }
    
    public func deStringify(_ string: String, linkDelegate: LinkDelegate) -> [Link] {
        var l = [Link]()
        let ls = string.characters.split(separator: ",").map(String.init)
        for linkStr in ls {
            let items = linkStr.characters.split(separator: ";").map(String.init)
            let point: CGPoint = CGPoint(x: (items[1] as NSString).doubleValue , y: (items[2] as NSString).doubleValue)
            let link = Link(origin: point, noteTitle: items[0])
            link.delegate = linkDelegate
            l.append(link)
        }
        return l
    }
    
    public func stringify() -> String {
        var str = ""
        for link in self.links {
            str += link.noteTitle + ";" + link.origin.x.description + ";" + link.origin.y.description + ","
        }
        return str
    }
}
