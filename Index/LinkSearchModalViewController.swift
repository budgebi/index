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

protocol LinkTableViewDelegate: class {
    func linkCount() -> Int
    
    func linkForIndexPath(indexPath: IndexPath) -> Note
    
    func setLinkForNoteAtIndexPath(indexPath: IndexPath)
}

extension LinkSearchModalViewController: LinkTableViewDelegate {
    internal func linkCount() -> Int{
        return (self.delegate?.linkCount())!
    }
    
    internal func linkForIndexPath(indexPath: IndexPath) -> Note {
        return (self.delegate?.linkForIndexPath(indexPath: indexPath))!
    }
    
    internal func setLinkForNoteAtIndexPath(indexPath: IndexPath) {
        self.delegate?.setLinkForNoteAtIndexPath(indexPath: indexPath)
        self.parent?.dismiss(animated: true, completion: { 
            self.delegate?.linkChangeDetected()
        })
    }
}

class LinkSearchModalViewController: UIViewController {

    var tableViewController: LinkTableViewController!
    var searchController: LinkSearchController!
    var searchView: UIView!
    var segmentedControl: UISegmentedControl?
    
    var createButton: UIButton?
    var urlBar: UITextField?
    weak var delegate: LinkSearchModalDelegate?
    
    init(searchResultsUpdater: UISearchResultsUpdating) {
        super.init(nibName: nil, bundle: nil)
        
        self.tableViewController = LinkTableViewController(style: .plain)
        self.tableViewController.delegate = self
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
        self.segmentedControl = UISegmentedControl(items: ["Note", "Web"])
        self.segmentedControl?.selectedSegmentIndex = 0
        self.segmentedControl?.frame = CGRect(x: 0, y: 44, width: 350, height: 30)
        self.segmentedControl?.addTarget(self, action: #selector(segmentedControlToggled(sender:)), for: .valueChanged)
    }

    override func viewDidLayoutSubviews() {
        self.searchView.sizeToFit()
        self.searchController.searchBar.sizeToFit()
        self.tableViewController.tableView.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchView = UIView(frame: CGRect(x: 0, y: 74, width: 350, height: 44))
        
        self.searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 350, height: 44)

        self.searchView.addSubview(self.searchController.searchBar)
        self.view.addSubview(searchView)
        
        self.segmentedControl?.layer.cornerRadius = 0
        self.segmentedControl?.layer.borderWidth = 1
        self.segmentedControl?.layer.borderColor = segmentedControl?.tintColor.cgColor;
        self.segmentedControl?.layer.masksToBounds = true
        self.view.addSubview(self.segmentedControl!)
        
        self.searchController.searchBar.isTranslucent = false
        self.searchController.extendedLayoutIncludesOpaqueBars = true
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func segmentedControlToggled(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 1:
                urlBar = UITextField(frame: CGRect(x: 17, y: 0, width: 280, height: 44))
                urlBar?.placeholder = "URL"
                urlBar?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
                self.searchController.searchBar.removeFromSuperview()
                searchView?.layer.borderWidth = 8
                searchView?.layer.borderColor = UIColor(red: 201/255, green: 201/255, blue: 206/255, alpha: 1).cgColor
                searchView?.addSubview(urlBar!)
                
                createButton = UIButton(frame: CGRect(x: 0, y: 118, width: 350, height: 494-118))
                createButton?.setTitleColor(segmentedControl?.tintColor, for: .normal)
                createButton?.setTitle("Create", for: .normal)

                self.view.addSubview(createButton!)
            default:
                self.urlBar?.removeFromSuperview()
                createButton?.removeFromSuperview()
                self.searchView.addSubview(self.searchController.searchBar)
        }
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
