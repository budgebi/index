//
//  LinkTableViewController.swift
//  Index
//
//  Created by Brian Budge on 1/25/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

class LinkTableViewController: UITableViewController {
    
    // Delegate
    weak var delegate: LinkTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (delegate?.linkCount())!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil)
        {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: reuseIdentifier)
        }
        
        let note = delegate?.linkForIndexPath(indexPath: indexPath)
        
        cell?.textLabel?.text = note?.title
        cell?.detailTextLabel?.text = note?.tags
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.setLinkForNoteAtIndexPath(indexPath: indexPath)
    }
}
