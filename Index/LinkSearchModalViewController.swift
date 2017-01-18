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
    var navBar: UINavigationBar!
    var searchView: UIView!
    
    init(indexTableViewDelegate: IndexTableViewDelegate, searchResultsUpdater: UISearchResultsUpdating) {
        super.init(nibName: nil, bundle: nil)
        
        self.tableViewController = IndexTableViewController(style: .plain)
        self.tableViewController.delegate = indexTableViewDelegate
        
        searchController = LinkSearchController(searchResultsController: tableViewController)
        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.showsCancelButton = false
        searchController.delegate = self
        definesPresentationContext = true
        self.navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        self.view.superview?.layer.cornerRadius = 5.0
        self.view.superview?.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLayoutSubviews() {
        self.searchView.sizeToFit()
        self.searchController.searchBar.sizeToFit()
        self.navBar.sizeToFit()
        self.tableViewController.tableView.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                        
        searchView = UIView(frame: CGRect(x: 0, y: 44, width: Int(self.view.frame.size.width) , height: 44))
        
        self.searchController.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: 44)
        self.searchView.addSubview(self.searchController.searchBar)

        self.view.addSubview(searchView)

        navBar.barTintColor = UIColor.white
        
        let navBarFont = UIFont(name: "HelveticaNeue", size: 20.0)!
        navBar.titleTextAttributes = [NSFontAttributeName: navBarFont]
        
        let navBarFontLight = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        let navItem = UINavigationItem(title: "Link Selection");
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(dismissSelf));
        cancelItem.setTitleTextAttributes([NSFontAttributeName: navBarFontLight], for: .normal)
        navItem.leftBarButtonItem = cancelItem;
        navBar.setItems([navItem], animated: false)
        
        self.view.addSubview(navBar)
        
        self.searchController.searchBar.isTranslucent = false
        self.searchController.extendedLayoutIncludesOpaqueBars = true
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissSelf() {
        if self.view.isFirstResponder {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
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
