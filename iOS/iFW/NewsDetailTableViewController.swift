//
//  NewsDetailTableViewController.swift
//  iFW
//
//  Created by George Dan on 8/04/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import UIKit

class NewsDetailTableViewController: UITableViewController {

	var post: RSSItem!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath)
			
			let titleLabel = cell.viewWithTag(1000) as! UILabel
			let dateLabel = cell.viewWithTag(1001) as! UILabel
			
			titleLabel.text = post.title
			
			let dateFormatter = NSDateFormatter()
			// TODO: Localize date (format + timezone)
			dateFormatter.dateFormat = "dd/MM/yyyy"
			
			if let date = post.pubDate {
				dateLabel.text = dateFormatter.stringFromDate(date)
			} else {
				dateLabel.text = "Date not found"
			}
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
			
			let contentView = cell.viewWithTag(1000) as! UILabel
			
			contentView.text = post.itemDescription
			
			return cell
		}
    }
	
	override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 80
		}
		return UITableViewAutomaticDimension
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	@IBAction func shareButtonPressed(sender: UIBarButtonItem) {
		let activityItems = ["\(post.title!) (\(post.links[0].absoluteString)) via iFW"]
		let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		
		activityController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAirDrop, UIActivityTypePostToFlickr]
		
		self.presentViewController(activityController, animated: true, completion: nil)
	}
	
}
