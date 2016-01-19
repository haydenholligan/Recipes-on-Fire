//
//  Recipe+CoreDataProperties.swift
//  Recipes on Fire
//
//  Created by Hayden on 2016-01-18.
//  Copyright © 2016 Hayden Holligan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Recipe {

    @NSManaged var name: String?
    @NSManaged var ingredients: String?
    @NSManaged var instructions: String?
    @NSManaged var numberTimesMade: NSNumber?
    @NSManaged var image: NSData?

}
