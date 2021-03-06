//
//  AppDelegate.swift
//  Recipes on Fire
//
//  Created by Hayden on 2016-01-18.
//  Copyright © 2016 Hayden Holligan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupAppearance()
        if (!NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            let ingredients = "2 Cups flour \n4 teaspoons baking powder \n0.5 teaspoons salt \n0.25 cups sugar \n2 eggs, separated \n0.5 cups oil \n2 cups milk \nFresh berries \nIce cream \nMaple syrup"
            let instructions = "1. Sift the dry ingredients together in a large bowl \n2. Separate the eggs \n3. In small bowl, beat egg whites until stiff \n4. Mix together the egg yolks, milk and oil and stir slightly \n5. Add to dry ingredients and mix well \nFold in beaten egg whites \n6. Cook batter in waffle maker \n7. Top with berries, ice cream, and maple syrup \n8. Enjoy!"
            createNewRecipe("Dessert Waffles", ingredients: ingredients, instructions: instructions)
        }
        
        IQKeyboardManager.sharedManager().enable = true
        // Override point for customization after application launch.
        return true
    }
    
    func createNewRecipe(name:String, ingredients:String, instructions:String) {
        let entityDescription = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: managedObjectContext)
        let recipe = Recipe(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        recipe.name = name
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        recipe.image = UIImagePNGRepresentation(UIImage(named: "waffles")!)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Couldn't create new recipe")
        }
    }

    func setupAppearance() {
        let navigationStyle = UINavigationBar.appearance()
        navigationStyle.barTintColor = UIColor(red: 0.9, green: 0.1, blue: 0.0, alpha: 1.0)
        navigationStyle.tintColor = UIColor.whiteColor()
        navigationStyle.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "ca.holligan.Recipes_on_Fire" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Recipes_on_Fire", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

