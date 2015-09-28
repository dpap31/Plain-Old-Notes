//
//  MasterViewController.swift
//  Plain Old Notes
//
//  Created by Drew Pappas on 9/27/15.
//  Copyright (c) 2015 Drew Pappas. All rights reserved.
//

import UIKit

var objects:[String] = [String]()
var currentIndex:Int = 0
var masterView:MasterViewController?
var detailViewController:DetailViewController?

let kNotes:String = "notes"
let BLANK_NOTE:String = "(New note)"


class MasterViewController: UITableViewController {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        masterView = self
        load()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    
    override func viewDidAppear(animated: Bool) {
        save()
        if objects.count == 0 {
          insertNewObject(self)
        }
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        if objects.count == 0 || objects[0] != BLANK_NOTE{
            objects.insert(BLANK_NOTE, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        currentIndex = 0
        self.performSegueWithIdentifier("showDetail", sender: self)
    }

//    func insertNewObject(sender: AnyObject) {
//        if objects.count == 0 || objects[0] != BLANK_NOTE{
//            objects.insert(BLANK_NOTE, atIndex: 0)
//            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        }
//        currentIndex = 0
//        self.performSegueWithIdentifier("showDetail", sender: self)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row]
                currentIndex = indexPath.row
//            (segue.destinationViewController as DetailViewController).detailItem = object
                detailViewController?.detailItem = object
                detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                detailViewController?.navigationItem.leftItemsSupplementBackButton == true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            return
        }
        save()
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        save()
    }
    
    func save(){
        NSUserDefaults.standardUserDefaults().setObject(objects, forKey: kNotes)
        NSUserDefaults.standardUserDefaults().synchronize()
    
    }

    func load(){
        if let loadedData = NSUserDefaults.standardUserDefaults().arrayForKey(kNotes) as? [String] {
            objects = loadedData
        } else{}
        
    }


}

