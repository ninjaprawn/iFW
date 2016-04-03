//
//  CDManager.swift
//  iFW
//
//  Created by George Dan on 28/03/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Class for managing CoreData (oops)
class CDManager {
	
	// memes
	static let sharedManager = CDManager()
	
	let managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	func saveCoreData(failCallBack: (() -> Void)?) {
		do {
			try self.managedObjectContext!.save()
		} catch {
			if let callback = failCallBack {
				callback()
			} else {
				abort()
			}
		}
	}
	
	private var _fetchedResultsController: NSFetchedResultsController? = nil
	
	var fetchedResultsController: NSFetchedResultsController {
		
		// Checks whether an existing fetched results controller exists. If so, return it. If not, proceed
		// with the rest of this code to create one!
		if _fetchedResultsController != nil {
			return _fetchedResultsController!
		}
		
		// Create a fetch request to get the objects from Core Data
		let fetchRequest = NSFetchRequest()
		
		// Describe what we want to get
		let entity = NSEntityDescription.entityForName("Device", inManagedObjectContext: self.managedObjectContext!)
		fetchRequest.entity = entity
		
		// Set the batch size to a suitable number
		fetchRequest.fetchBatchSize = 100
		
		// Edit the sort key as appropriate.
		let sortDescriptorLastName = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptorLastName]
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
		//aFetchedResultsController.delegate = self
		_fetchedResultsController = aFetchedResultsController
		
		// Attempts to perform the fetch
		do {
			try _fetchedResultsController!.performFetch()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			// print("Unresolved error \(error), \(error.userInfo)")
			abort()
		}
		
		return _fetchedResultsController!
		
	}

	
}