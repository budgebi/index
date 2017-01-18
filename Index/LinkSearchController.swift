//
//  LinkSearchController.swift
//  Index
//
//  Created by Brian Budge on 1/17/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

class LinkSearchController: UISearchController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var _searchBar: LinkSearchBar {
        get {
            let result = LinkSearchBar(frame: CGRect.zero)
            result.delegate = self
            
            return result
        }
    }
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }

}
