//
//  LinkSearchModalViewController.swift
//  Index
//
//  Created by Brian Budge on 1/14/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

extension LinkSearchModalViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
}

class LinkSearchModalViewController: UIViewController {

    var tableViewController: IndexTableViewController!
    var searchController: LinkSearchController!
    var searchView: UIView!
    
    init(indexTableViewDelegate: IndexTableViewDelegate, searchResultsUpdater: UISearchResultsUpdating) {
        super.init(nibName: nil, bundle: nil)
        
        self.tableViewController = IndexTableViewController(style: .plain)
        self.tableViewController.delegate = indexTableViewDelegate
        self.tableViewController.extendedLayoutIncludesOpaqueBars = true
        
        searchController = LinkSearchController(searchResultsController: tableViewController)
        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.showsCancelButton = false
        searchController.delegate = self
        searchController.definesPresentationContext = true
        definesPresentationContext = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        self.view.superview?.layer.cornerRadius = 0.0
        self.view.superview?.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLayoutSubviews() {
        self.searchView.sizeToFit()
        self.searchController.searchBar.sizeToFit()
        self.tableViewController.tableView.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchView = UIView(frame: CGRect(x: 0, y: 0, width: 250 , height: 44))
        
        self.searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 250, height: 44)
        
        self.searchView.addSubview(self.searchController.searchBar)

        self.view.addSubview(searchView)
        
        self.searchController.searchBar.isTranslucent = false
        self.searchController.extendedLayoutIncludesOpaqueBars = true
        extendedLayoutIncludesOpaqueBars = true
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
