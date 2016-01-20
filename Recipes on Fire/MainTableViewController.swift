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
        self.tableView.rowHeight = 100
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

       tryPerformFetchAndReloadData()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        
        tryPerformFetchAndReloadData()
    }
    
    func tryPerformFetchAndReloadData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to perform initial fetch")
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultsController.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = fetchedResultsController.sections?[section].numberOfObjects
        return numberOfRows!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "RecipeCell"
        let cell: RecipeTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecipeTableViewCell

        let recipe = fetchedResultsController.objectAtIndexPath(indexPath) as! Recipe
        
        cell.recipeLabel.text = recipe.name
        if recipe.image != nil {
        cell.recipeImage.image = UIImage(data: recipe.image!)
        } else {
            cell.recipeImage.image = UIImage(named: "Placeholder Dark")
        }
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
            
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Delete {
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit" {
            let cell = sender as! RecipeTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let addController = segue.destinationViewController as! AddViewController
            let recipe = fetchedResultsController.objectAtIndexPath(indexPath!) as! Recipe
            addController.recipe = recipe
        }
    }

}
