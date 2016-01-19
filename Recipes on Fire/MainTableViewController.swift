//
//  MainTableViewController.swift
//  Recipes on Fire
//
//  Created by Hayden on 2016-01-18.
//  Copyright © 2016 Hayden Holligan. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultsController = NSFetchedResultsController()
    
    func fetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        return NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing initial fetch")
            return
        }
        
        self.tableView.rowHeight = 60
        self.tableView.reloadData()
        
    }
    
    
    //Is this necessary??
    override func viewDidAppear(animated: Bool) {
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to perform initial fetch")
        }
        
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let recipe = fetchedResultsController.objectAtIndexPath(indexPath) as! Recipe
        cell.textLabel?.text = recipe.name
        cell.imageView?.image = UIImage(data: recipe.image!)
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let managedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            managedObjectContext.deleteObject(managedObject)
            do {
                try managedObjectContext.save()
            } catch {
                print("Failed to delete item")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let addController = segue.destinationViewController as! AddViewController
            let recipe = fetchedResultsController.objectAtIndexPath(indexPath!) as! Recipe
            addController.recipe = recipe
        }
    }

}
