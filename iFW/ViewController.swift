//
//  ViewController.swift
//  iFW
//
//  Created by George Dan on 28/03/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {

	let realm = try! Realm()
	var devices: Results<Device>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dispatch_async(dispatch_get_main_queue(), {
			APIManager().downloadInfo({
				self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
			})
		})
		devices = realm.objects(Device).sorted("deviceName")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if devices.count > 0 {
			return devices.count
		}
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if devices.count > 0  {
			let cell = tableView.dequeueReusableCellWithIdentifier("detail", forIndexPath: indexPath)
			
			cell.textLabel?.text = devices[indexPath.row].deviceName
			cell.detailTextLabel?.text = "\(devices[indexPath.row].firmwares.count)"
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("title", forIndexPath: indexPath)
			
			cell.textLabel?.text = "No devices found in Realm"
			
			return cell
		}
		
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Count: \(devices.count)"
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "deviceFirmwares" {
			let destinationViewController = segue.destinationViewController as! FirmwareTableViewController
			let index = self.tableView.indexPathForCell((sender as! UITableViewCell))!.row
			destinationViewController.device = devices[index]
		}
		
		let backItem = UIBarButtonItem()
		backItem.title = ""
		navigationItem.backBarButtonItem = backItem
	}
	
}

