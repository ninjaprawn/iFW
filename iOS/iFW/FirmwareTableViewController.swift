//
//  FirmwareTableViewController.swift
//  iFW
//
//  Created by George Dan on 31/03/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import UIKit

class FirmwareTableViewController: UITableViewController {

	var device: Device!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = device.deviceName
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return device.firmwares.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detail", forIndexPath: indexPath)

        cell.textLabel?.text = device.firmwares[indexPath.row].version
		cell.detailTextLabel?.text = device.firmwares[indexPath.row].buildID
		
		if device.firmwares[indexPath.row].signed {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}

        return cell
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
}
