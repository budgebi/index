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
    var navBar: UINavigationBar!
    
    init(indexTableViewDelegate: IndexTableViewDelegate, searchResultsUpdater: UISearchResultsUpdating) {
        super.init(nibName: nil, bundle: nil)
        
        self.tableViewController = IndexTableViewController(style: .plain)
        self.tableViewController.delegate = indexTableViewDelegate
        
        searchController = UISearchController(searchResultsController: tableViewController)
        self.searchController.searchResultsUpdater = searchResultsUpdater
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
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
        self.searchController.searchBar.sizeToFit()
        self.navBar.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchController.searchBar.frame = CGRect(x: 0, y: 44, width: self.view.frame.size.width , height: 44)
        self.view.addSubview(self.searchController.searchBar)

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
        
        self.searchController.extendedLayoutIncludesOpaqueBars = !navBar.isTranslucent
        extendedLayoutIncludesOpaqueBars = !navBar.isTranslucent

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
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
