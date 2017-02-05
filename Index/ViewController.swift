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
    func addNewLink(linkLocation: CGPoint)
    func changeDetected()
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
            note.setValue(self.links.stringify(), forKey: "links")
            note.setValue(self.paperBackground.cornell, forKey: "cornell")
            currNote = note
        } else {
            currNote?.setValue(title, forKeyPath: "title")
            currNote?.setValue(tags, forKeyPath: "tags")
            currNote?.setValue(Date(), forKey: "date")
            currNote?.setValue(paperType, forKey: "paperType")
            currNote?.setValue(self.paperBackground.cornell, forKey: "cornell")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func cancelLink() {
        self.linkNav?.dismiss(animated: true, completion: nil)
    }
    
    internal func addNewLink(linkLocation: CGPoint) {
        self.linkLocation = linkLocation
        self.linkSearchModal = LinkSearchModalViewController(searchResultsUpdater: self)
        self.linkSearchModal?.delegate = self
        self.linkNav = UINavigationController(rootViewController: linkSearchModal!)
        self.linkNav?.modalPresentationStyle = .formSheet
        self.linkNav?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        self.linkNav?.navigationBar.topItem?.title = "Select a Link"
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelLink))
        self.linkNav?.navigationBar.topItem?.leftBarButtonItem = cancelButton
        let popover = self.linkNav?.popoverPresentationController
        
        self.linkSearchModal?.preferredContentSize = CGSize(width: 350, height: 450)
        popover?.delegate = self
        
        present(self.linkNav!, animated: true, completion: nil)
    }
    
    internal func changeDetected() {
        self.saveButton.isEnabled = true
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
        self.loadNote(note: self.searchResults[indexPath.row])
        
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.searchBar.showsCancelButton = false
    }
}

protocol LinkSearchModalDelegate: class {
    func linkCount() -> Int
    
    func linkForIndexPath(indexPath: IndexPath) -> Note
    
    func setLinkForNoteAtIndexPath(indexPath: IndexPath)
    
    func linkChangeDetected()
}

extension ViewController: LinkSearchModalDelegate {
    internal func linkCount() -> Int{
        return self.searchResults.count
    }
    
    internal func linkForIndexPath(indexPath: IndexPath) -> Note {
        return self.searchResults[indexPath.row]
    }
    
    internal func setLinkForNoteAtIndexPath(indexPath: IndexPath) {
        let note: Note = self.searchResults[indexPath.row]
        let origin = CGPoint(x: (self.linkLocation?.x)!, y: (self.linkLocation?.y)! - 6 + self.scrollView.contentOffset.y)
        let link = Link(origin: origin, noteTitle: note.title!)
        link.delegate = self

        self.paperView.addSubview(link.button)
        self.links.add(link)
    }
    
    internal func linkChangeDetected() {
        self.saveButton.isEnabled = true
    }
}

protocol LinkDelegate: class {
    func loadLink(link: Link)
}

extension ViewController: LinkDelegate {
    internal func loadLink(link: Link) {
        let note = self.findNoteByTitle(title: link.noteTitle)
        self.loadNote(note: note)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        let tvc = (searchController.searchResultsController) as! UITableViewController
        tvc.tableView.reloadData()
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {}

class ViewController: UIViewController {

    fileprivate var colorOptionsDisplayed = false
    fileprivate var sizeOptionsDisplayed = false
    fileprivate var paperOptionsDisplayed = false
    fileprivate var drawStyleOptionsDisplayed = false
    
    fileprivate let paperColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

    @IBOutlet weak var paperView: PaperView!
    @IBOutlet weak var paperBackground: PaperBackgroundView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: PaperScrollView!
    
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var tableViewController: IndexTableViewController!
    var searchController: UISearchController!
    
    fileprivate var currNote: NSManagedObject?
    fileprivate var prevNotes: [NSManagedObject] = []

    fileprivate var paperType: String = "plain"

    fileprivate var searchResults = [Note]()
    
    fileprivate var links: Links!
    
    public var linkSearchModal: LinkSearchModalViewController?
    public var linkNav: UINavigationController?
    fileprivate var linkLocation: CGPoint?
    
    // Lifecycle Hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paperView.delegate = self
        self.paperView.isUserInteractionEnabled = true
        self.paperBackground.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        paperBackground.backgroundColor = paperColor
        
        self.tableViewController = IndexTableViewController(style: .plain)
        self.tableViewController.delegate = self
        self.tableViewController.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
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
        self.searchController.view.backgroundColor = UIColor.clear
        
        self.links = Links(links: [Link]())
        
        self.linkButton.setImage(UIImage(named: "LinkSelected"), for: .selected)
        self.eraseButton.setImage(UIImage(named: "EraseFilledSelected"), for: .selected)
        self.drawButton.setImage(UIImage(named: "EditSelected"), for: .selected)
        self.saveButton.setImage(UIImage(named: "SaveDisabled"), for: .disabled)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        paperBackground.drawPlainPaper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Note creation and deletion
    @IBAction func newNote() {
        if self.saveButton.isEnabled {
            let newAlert = UIAlertController(title: "New Note", message: "Any unsaved changes will be lost!", preferredStyle: UIAlertControllerStyle.alert)
            newAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                if self.prevNotes.count > 20 {
                    self.prevNotes.remove(at: 0)
                }
                if self.currNote != nil {
                    self.prevNotes.append(self.currNote!)
                }
                self.currNote = nil
                self.paperView.deleteNote()
                self.removeLinksFromView()
                if self.paperBackground.cornell {
                    self.cornellButtonPressed()
                }
                self.saveButton.isEnabled = false
            }))
        
            newAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                return
            }))
            
            present(newAlert, animated: true, completion: nil)
        } else {
            if self.prevNotes.count > 20 {
                self.prevNotes.remove(at: 0)
            }
            if self.currNote != nil {
                self.prevNotes.append(self.currNote!)
            }
            self.currNote = nil
            self.paperView.deleteNote()
            self.removeLinksFromView()
            if self.paperBackground.cornell {
                self.cornellButtonPressed()
            }
            self.saveButton.isEnabled = false
        }
    }
    
    @IBAction func deleteNote() {
        
        let deleteAlert = UIAlertController(title: "Delete Note", message: "The note will be permanently deleted!", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction!) in
            self.removeLinksFromView()
            self.paperView.deleteNote()
            self.saveButton.isEnabled = false
            if self.paperBackground.cornell {
                self.cornellButtonPressed()
            }
            if self.currNote == nil {
                return
            }
            
            if self.prevNotes.contains(self.currNote!) {
                let index = self.prevNotes.index(of: self.currNote!)
                self.prevNotes.remove(at: index!)
            }
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            if(self.currNote != nil) {
                managedContext.delete(self.currNote!)
                self.currNote = nil
            }
            do {
                try managedContext.save()
            } catch _ {
            }
            
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            return
        }))
        
        present(deleteAlert, animated: true, completion: nil)

    }
    
    @IBAction func saveNote() {
        self.paperView.saveNote()
        self.saveButton.isEnabled = false
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

    // Commands
    @IBAction func eraserButtonPressed() {
        self.paperView.useEraser()
        self.eraseButton.isSelected = true
        self.drawButton.isSelected = false
        self.linkButton.isSelected = false
    }
    
    @IBAction func paperButtonPressed(sender: AnyObject) {
        let paperButton = sender as! UIButton
        if paperType != paperButton.accessibilityIdentifier {
            self.changeDetected()
        }
        paperType = paperButton.accessibilityIdentifier!
        paperBackground.setPaper(paper: paperType)

        animateOptionSlide(button: paperButton, start: 60, end: 62, hide: paperOptionsDisplayed)
        paperOptionsDisplayed = !paperOptionsDisplayed
    }
    
    @IBAction func drawStyleButtonPressed(sender: AnyObject) {
        let drawStyleButton = sender as! UIButton
        if drawStyleButton.accessibilityIdentifier! == "line" {
            self.drawButton.setImage(UIImage(named: "LineSelected"), for: .selected)
        } else {
            self.drawButton.setImage(UIImage(named: "EditSelected"), for: .selected)
        }
        paperView.setDrawStyle(style: drawStyleButton.accessibilityIdentifier!)

        animateOptionSlide(button: drawStyleButton, start: 1, end: 2, hide: drawStyleOptionsDisplayed)
        drawStyleOptionsDisplayed = !drawStyleOptionsDisplayed
        
        self.drawButton.isSelected = true
        self.eraseButton.isSelected = false
        self.linkButton.isSelected = false
    }
    
    @IBAction func sizeButtonPressed(sender: AnyObject) {
        self.drawButton.isSelected = true
        self.eraseButton.isSelected = false
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
        self.changeDetected()
    }
    
    @IBAction func backButtonPressed() {
        if self.prevNotes.count == 0 {
            return
        }
        self.removeLinksFromView()

        self.currNote = self.prevNotes[self.prevNotes.count-1]
        self.prevNotes.remove(at: self.prevNotes.count-1)
        self.paperView.loadNote(note: self.currNote as! Note, documentsDirectory: getDocumentsDirectory())
        
        self.paperBackground.cornell = (self.currNote as! Note).cornell
        paperBackground.setPaper(paper: (self.currNote as! Note).paperType!)
        
        if (self.currNote as! Note).links != nil && (self.currNote as! Note).links != ""{
            self.links = Links(string: (self.currNote as! Note).links! as String, linkDelegate: self)
            for link in self.links.links {
                self.paperView.addSubview(link.button)
            }
        }
    }
    
    @IBAction func cornellButtonPressed() {
        self.paperBackground.drawCornellTemplate()
        self.changeDetected()
    }
    
    @IBAction func linkButtonPressed() {
        self.paperView.useLink()
        self.linkButton.isSelected = true
        self.drawButton.isSelected = false
        self.eraseButton.isSelected = false
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // Animation stuffs
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
    }
    
    // Load Note
    func loadNote(note: Note) {
        self.removeLinksFromView()
        self.saveButton.isEnabled = false
        if self.prevNotes.count > 20 {
            self.prevNotes.remove(at: 0)
        }
        if self.currNote != nil {
            self.prevNotes.append(self.currNote!)
        }
        self.currNote = note
        self.paperView.loadNote(note: self.currNote as! Note, documentsDirectory: getDocumentsDirectory())
        
        self.paperBackground.cornell = (self.currNote as! Note).cornell
        paperBackground.setPaper(paper: (self.currNote as! Note).paperType!)
        
        if note.links != nil && note.links != ""{
            self.links = Links(string: note.links! as String, linkDelegate: self)
            for link in self.links.links {
                self.paperView.addSubview(link.button)
            }
        }
    }
    
    func findNoteByTitle(title: String) -> Note{
        let notes = self.fetchNotes()
        for note in notes {
            if note.title == title {
                return note
            }
        }
        return self.currNote as! Note
    }
    
    func removeLinksFromView() {
        for link in self.links.links {
            link.button.removeFromSuperview()
        }
        self.links.links = []
    }
    
    
}

