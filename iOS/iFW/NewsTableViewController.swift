//
//  NewsTableViewController.swift
//  iFW
//
//  Created by George Dan on 4/04/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, AppNotificationDelegate {

	var items = [RSSItem]()
	var oldRightButton: UIBarButtonItem!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.fetchNews()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		(UIApplication.sharedApplication().delegate as! AppDelegate).notificationDelegate = self
	}
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath)

		let titleLabel = cell.viewWithTag(1000) as! UILabel
		let dateLabel = cell.viewWithTag(1001) as! UILabel
		
		titleLabel.text = items[indexPath.row].title
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = .ShortStyle
		dateFormatter.timeStyle = .NoStyle
		dateFormatter.locale = NSLocale.currentLocale()
		dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
		
		if let date = items[indexPath.row].pubDate {
			dateLabel.text = dateFormatter.stringFromDate(date).fixDate()
		} else {
			dateLabel.text = "Date not found"
		}

        return cell
    }

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "postDetail" {
			let destVC = segue.destinationViewController as! NewsDetailTableViewController
			if let indexPath = sender as? NSIndexPath {
				destVC.post = items[indexPath.row]
			} else if let cell = sender as? UITableViewCell {
				let index = self.tableView.indexPathForCell(cell)!.row
				destVC.post = items[index]
			}
		}
		
		let backItem = UIBarButtonItem()
		backItem.title = ""
		navigationItem.backBarButtonItem = backItem
	}
	
	func openCell(indexPath: NSIndexPath) {
		self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
		self.performSegueWithIdentifier("postDetail", sender: indexPath)
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	func findItemWithTitle(title: String) -> Int? {
		var index: Int? = nil
		
		self.items.enumerate().forEach({ (ind, item) in
			if item.title == title {
				index = ind
				return
			}
		})
		
		return index
	}
	
	func beginActivity() {
		self.oldRightButton = self.navigationItem.rightBarButtonItem!
		let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
		indicator.startAnimating()
		let item = UIBarButtonItem(customView: indicator)
		
		self.navigationItem.rightBarButtonItem = item
	}
	
	func stopActivity() {
		self.navigationItem.rightBarButtonItem = self.oldRightButton
	}
	
	func fetchNews() {
		self.beginActivity()
		dispatch_async(dispatch_get_main_queue(), {
			let request: NSURLRequest = NSURLRequest(URL: NSURL(string: "https://ipsw.me/updates.rss")!)
			RSSParser.parseFeedForRequest(request, callback: { (feed, error) in
				guard let feed = feed else {
					print(error)
					self.stopActivity()
					return
				}
				
				self.items = feed.items
				dispatch_sync(dispatch_get_main_queue(), {
					self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
					self.stopActivity()
					if let title = NSUserDefaults.standardUserDefaults().stringForKey("notificationTitle") {
						if let indexForTitle = self.findItemWithTitle(title) {
							self.openCell(NSIndexPath(forRow: indexForTitle, inSection: 0))
						}
						NSUserDefaults.standardUserDefaults().removeObjectForKey("notificationTitle")
					}
				})
				
			})
		})
	}
	
	@IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
		self.fetchNews()
	}
	
	func appDidReceiveNotificationWithMessage(message: String) {
		NSUserDefaults.standardUserDefaults().setObject(message, forKey: "notificationTitle")
		self.fetchNews()
	}
	
}
