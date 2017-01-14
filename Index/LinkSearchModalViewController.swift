//
//  LinkSearchModalViewController.swift
//  Index
//
//  Created by Brian Budge on 1/14/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

class LinkSearchModalViewController: UIViewController {

    var tableViewController: IndexTableViewController!
    var searchController: UISearchController!
    
    init(indexTableViewDelegate: IndexTableViewDelegate, searchResultsUpdater: UISearchResultsUpdating) {
        super.init(nibName: nil, bundle: nil)
        
        self.tableViewController = IndexTableViewController(style: .plain)
        self.tableViewController.delegate = indexTableViewDelegate
        
        searchController = UISearchController(searchResultsController: tableViewController)
        self.searchController.searchResultsUpdater = searchResultsUpdater
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.extendedLayoutIncludesOpaqueBars = true
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
        
        self.view.addSubview(self.searchController.searchBar)
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.frame.size.width = self.view.frame.size.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
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

}
