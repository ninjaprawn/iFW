//
//  ViewController.swift
//  iFW
//
//  Created by George Dan on 28/03/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		APIManager().downloadInfo()
		//APIManager().coreDataToJson()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let fetchedObjects = CDManager.sharedManager.fetchedResultsController.fetchedObjects {
			return fetchedObjects.count
		}
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("detail", forIndexPath: indexPath)
		
		if let fetchedObjects = CDManager.sharedManager.fetchedResultsController.fetchedObjects {
			cell.textLabel?.text = (fetchedObjects[indexPath.row] as! Device).name
			cell.detailTextLabel?.text = "\((fetchedObjects[indexPath.row] as! Device).firmwares!.count)"
		} else {
			cell.textLabel?.text = "No Devices Found in CD"
		}
		
		return cell
		
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let fetchedObjects = CDManager.sharedManager.fetchedResultsController.fetchedObjects {
			return "Count: \(fetchedObjects.count)"
		}
		return "Count: 0"
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "deviceFirmwares" {
			let destinationViewController = segue.destinationViewController as! FirmwareTableViewController
			let index = self.tableView.indexPathForCell((sender as! UITableViewCell))!.row
			destinationViewController.device = CDManager.sharedManager.fetchedResultsController.fetchedObjects![index] as! Device
		}
	}
	
}

