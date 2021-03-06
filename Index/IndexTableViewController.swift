//
//  IndexTableViewController.swift
//  Index
//
//  Created by Brian Budge on 1/1/17.
//  Copyright © 2017 Brian Budge. All rights reserved.
//

import UIKit

class IndexTableViewController: UITableViewController {

    // Delegate
    weak var delegate: IndexTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (delegate?.noteCount())!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil)
        {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: reuseIdentifier)
        }
        
        let note = delegate?.noteForIndexPath(indexPath: indexPath)
        
        cell?.textLabel?.text = note?.title
        cell?.detailTextLabel?.text = note?.tags
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.loadNoteForIndexPath(indexPath: indexPath)
        self.dismiss(animated: false, completion: nil)
    }
}
