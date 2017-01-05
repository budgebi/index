//
//  ViewController.swift
//  Index
//
//  Created by Brian Budge on 9/25/16.
//  Copyright © 2016 Brian Budge. All rights reserved.
//

import UIKit
import CoreData

protocol PaperViewDelegate: class {
    func saveNote(title: String, tags: String, image: UIImage)
}

extension ViewController: PaperViewDelegate {
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    internal func saveNote(title: String, tags: String, image: UIImage) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let fileName = title + ".png"
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let data = UIImagePNGRepresentation(image)
        try? data?.write(to: path)

        if currNote == nil {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        
            let note = NSManagedObject(entity: entity, insertInto: managedContext)
        
            note.setValue(title, forKeyPath: "title")
            note.setValue(tags, forKeyPath: "tags")
            note.setValue(fileName, forKeyPath: "imagePath")
            note.setValue(Date(), forKey: "date")
            note.setValue(paperType, forKey: "paperType")
            currNote = note
        } else {
            currNote?.setValue(title, forKeyPath: "title")
            currNote?.setValue(tags, forKeyPath: "tags")
            currNote?.setValue(Date(), forKey: "date")
            currNote?.setValue(paperType, forKey: "paperType")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

protocol IndexTableViewDelegate: class {
    func noteCount() -> Int
    
    func noteForIndexPath(indexPath: IndexPath) -> Note
    
    func loadNoteForIndexPath(indexPath: IndexPath)
}

extension ViewController: IndexTableViewDelegate {
    internal func noteCount() -> Int{
        return self.searchResults.count
    }
    
    internal func noteForIndexPath(indexPath: IndexPath) -> Note {
        return self.searchResults[indexPath.row]
    }
    
    internal func loadNoteForIndexPath(indexPath: IndexPath) {
        self.currNote = self.searchResults[indexPath.row]
        self.paperView.loadNote(note: self.currNote as! Note, documentsDirectory: getDocumentsDirectory())
        paperBackground.setPaper(paper: (self.currNote as! Note).paperType!)
        
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.searchBar.showsCancelButton = false
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class ViewController: UIViewController {

    fileprivate var colorOptionsDisplayed = false
    fileprivate var sizeOptionsDisplayed = false
    fileprivate var paperOptionsDisplayed = false
    fileprivate var drawStyleOptionsDisplayed = false
    
    fileprivate let paperColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

    @IBOutlet weak var paperView: PaperView!
    @IBOutlet weak var paperBackground: PaperBackgroundView!
    @IBOutlet weak var topView: UIView!
    
    var tableViewController: IndexTableViewController!
    var searchController: UISearchController!
    
    fileprivate var currNote: NSManagedObject?;
    fileprivate var paperType: String = "plain";

    fileprivate var searchResults = [Note]();
    
    // Lifecycle Hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paperView.delegate = self
        paperBackground.backgroundColor = paperColor
        
        self.tableViewController = IndexTableViewController(style: .plain)
        self.tableViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: tableViewController)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.extendedLayoutIncludesOpaqueBars = true
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
        
        self.searchController.searchBar.barTintColor = UIColor.init(red: 96/255, green: 125/255, blue: 139/255, alpha: 1)
        self.searchController.searchBar.tintColor = UIColor.white
        self.topView.addSubview(self.searchController.searchBar)
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.frame.size.width = self.view.frame.size.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        paperBackground.drawPlainPaper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func newNote() {
        currNote = nil
        self.paperView.deleteNote()
    }
    
    @IBAction func deleteNote() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext

        if(currNote != nil) {
            managedContext.delete(currNote!)
            currNote = nil
        }

        self.paperView.deleteNote()

    }
    
    @IBAction func saveNote() {
        self.paperView.saveNote()
    }
    
    func fetchNotes() -> [Note] {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return [];
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Note")
        
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [Note];
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return [];
        }
    }

    @IBAction func eraserButtonPressed() {
        self.paperView.useEraser()
    }
    
    @IBAction func paperButtonPressed(sender: AnyObject) {
        let paperButton = sender as! UIButton
        paperType =  paperButton.accessibilityIdentifier!
        paperBackground.setPaper(paper: paperType)

        animateOptionSlide(button: paperButton, start: 60, end: 62, hide: paperOptionsDisplayed)
        paperOptionsDisplayed = !paperOptionsDisplayed
    }
    
    @IBAction func drawStyleButtonPressed(sender: AnyObject) {
        let drawStyleButton = sender as! UIButton
        paperView.setDrawStyle(style: drawStyleButton.accessibilityIdentifier!)

        animateOptionSlide(button: drawStyleButton, start: 1, end: 2, hide: drawStyleOptionsDisplayed)
        drawStyleOptionsDisplayed = !drawStyleOptionsDisplayed
    }
    
    @IBAction func sizeButtonPressed(sender: AnyObject) {
        let sizeButton = sender as! UIButton
        paperView.setLineWidth(lWidth: sizeButton.accessibilityIdentifier!)

        animateOptionSlide(button: sizeButton, start: 20, end: 22, hide: sizeOptionsDisplayed)
        sizeOptionsDisplayed = !sizeOptionsDisplayed
    }
    
    @IBAction func colorCommand(sender: AnyObject) {
        let colorButton = sender as! UIButton
        paperView.setDrawColor(color: colorButton.accessibilityIdentifier!)
        
        animateOptionSlide(button: colorButton, start: 10, end: 14, hide: colorOptionsDisplayed)
        colorOptionsDisplayed = !colorOptionsDisplayed
    }
    
    @IBAction func undoButtonPressed() {
        self.paperView.undo()
    }
    
    func animateOptionSlide(button: UIButton, start: Int, end: Int, hide: Bool) {
        if(button.tag != start) {
            let selectedOption = self.view.viewWithTag(start) as! UIButton
            let prevImage = selectedOption.image(for: .normal)
            let prevIdentifier = selectedOption.accessibilityIdentifier
            
            let newImage = button.image(for: .normal)
            selectedOption.setImage(newImage, for: .normal)
            selectedOption.accessibilityIdentifier = button.accessibilityIdentifier
            
            button.setImage(prevImage, for: .normal)
            button.accessibilityIdentifier = prevIdentifier
        }
        
        animateOptions(hide: hide, startTag: start, endTag: end)
    }
    
    func animateOptions(hide: Bool, startTag: Int, endTag: Int) {
        let start: CGFloat!
        let end: CGFloat!
        let tagInc: Int!
        var beginTag: Int!
        if hide == true {
            start = 1
            end = 0
            tagInc = -1
            beginTag = endTag + 1
            
        } else {
            start = 0
            end = 1
            tagInc = 1
            beginTag = startTag
        }
        
        let steps = endTag - startTag
        
        let delay: TimeInterval = 0.0
        let duration: TimeInterval = Double(steps+1) * 0.05
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: .calculationModeLinear, animations: {
            
            for i in 1...steps {
                beginTag = beginTag + tagInc
                let colorOption = self.view.viewWithTag(beginTag) as! UIButton
                colorOption.alpha = start

                UIView.addKeyframe(withRelativeStartTime: Double(i)/Double(steps+1), relativeDuration: Double(1)/Double(steps+1), animations: {
                    colorOption.isEnabled = true
                    colorOption.isHidden = false
                    colorOption.alpha = end
                })
            }
            
            }, completion: {finished in
        })
    }
    
    // Searching Stuffs
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let notes = fetchNotes()
        searchResults = notes
        if searchText != "" {
            searchResults = notes.filter{ note in
                return (note.title?.lowercased().contains(searchText.lowercased()))! || (note.tags?.lowercased().contains(searchText.lowercased()))!
            }
        } else {
            tableViewController.tableView.isHidden = false
        }
        
        searchResults.sort {a,b in
            a.date?.compare(b.date as! Date) == ComparisonResult.orderedDescending
        }
        
        tableViewController.tableView.reloadData()
    }
    
    
}

