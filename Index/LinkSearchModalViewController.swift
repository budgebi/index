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
    var typeToggleView: UIView!
    var note: UIButton?
    var web: UIButton?
    var urlBar: UITextField?
    weak var delegate: LinkSearchModalDelegate?
    
    init(searchResultsUpdater: UISearchResultsUpdating) {
        super.init(nibName: nil, bundle: nil)
        
        self.tableViewController = LinkTableViewController(style: .plain)
        self.tableViewController.delegate = self
        self.tableViewController.extendedLayoutIncludesOpaqueBars = true
        self.tableViewController.preferredContentSize = CGSize(width: 200, height: 406)
        self.tableViewController.tableView.frame.size.width = 200
        
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
        searchView = UIView(frame: CGRect(x: 70, y: 44, width: 280, height: 44))
        
        self.searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 280, height: 44)
        self.typeToggleView = UIView(frame: CGRect(x: 0, y: 44, width: 70, height: 44))
        self.typeToggleView.backgroundColor = UIColor(red: 201/255, green: 201/255, blue: 206/255, alpha: 1)
        
        self.note = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 22))
        self.web = UIButton(frame: CGRect(x: 0, y: 22, width: 70, height: 22))
        
        note?.setTitle("Note", for: .normal)
        note?.setTitleColor(self.view.tintColor, for: .selected)
        note?.setTitleColor(UIColor.lightGray, for: .normal)
        note?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
        note?.addTarget(self, action:  #selector(noteButtonPressed), for: UIControlEvents.touchUpInside)
        note?.isSelected = true
        
        web?.setTitle("Web", for: .normal)
        web?.setTitleColor(self.view.tintColor, for: .selected)
        web?.setTitleColor(UIColor.lightGray, for: .normal)
        web?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
        web?.addTarget(self, action:  #selector(webButtonPressed), for: UIControlEvents.touchUpInside)
        
        self.typeToggleView.addSubview(note!)
        self.typeToggleView.addSubview(web!)
        self.view.addSubview(self.typeToggleView)
        
        self.searchView.addSubview(self.searchController.searchBar)

        self.view.addSubview(searchView)
        
        self.searchController.searchBar.isTranslucent = false
        self.searchController.extendedLayoutIncludesOpaqueBars = true
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func noteButtonPressed() {
        note?.isSelected = true
        web?.isSelected = false
        urlBar?.removeFromSuperview()
        searchView.addSubview(searchController.searchBar)
    }
    
    func webButtonPressed() {
        note?.isSelected = false
        web?.isSelected = true
        urlBar = UITextField(frame: CGRect(x: 17, y: 0, width: 280, height: 44))
        urlBar?.placeholder = "URL"
        urlBar?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        
        searchView?.layer.borderWidth = 8
        searchView?.layer.borderColor = UIColor(red: 201/255, green: 201/255, blue: 206/255, alpha: 1).cgColor
        searchController.searchBar.removeFromSuperview()
        searchView.addSubview(urlBar!)
        self.view.frame.size.height = 88
        self.delegate?.webButtonPressed()
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
