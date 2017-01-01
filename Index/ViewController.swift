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
        let path = getDocumentsDirectory().appendingPathComponent(title + ".png")
        print(path)
        let data = UIImagePNGRepresentation(image)
        try? data?.write(to: path)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        
        note.setValue(title, forKeyPath: "title")
        note.setValue(tags, forKeyPath: "tags")
        note.setValue(path.absoluteString, forKeyPath: "imagePath")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        currNote = note
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate var colorOptionsDisplayed = false
    fileprivate var sizeOptionsDisplayed = false
    fileprivate var paperOptionsDisplayed = false
    fileprivate var drawStyleOptionsDisplayed = false
    
    fileprivate let paperColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

    @IBOutlet weak var paperView: PaperView!
    @IBOutlet weak var paperBackground: PaperBackgroundView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    
    fileprivate var currNote: NSManagedObject?;
    
    fileprivate var searchResults = [Note]();
    
    // Lifecycle Hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paperView.delegate = self
        paperBackground.backgroundColor = paperColor
        
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        self.topView.addSubview(self.searchController.searchBar)
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.frame.size.width = self.view.frame.size.width
        
        self.tableView.isHidden = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        paperBackground.drawPlainPaper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // TableView Stuffs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.searchResults[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        paperBackground.setPaper(paper: paperButton.accessibilityIdentifier!)

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
        searchResults = notes.filter{ note in
            return (note.title?.lowercased().contains(searchText.lowercased()))!
        }
        print(searchResults)
        self.tableView.isHidden = false

        tableView.reloadData()
    }
}

