//
//  NewsTableViewController.swift
//  iFW
//
//  Created by George Dan on 4/04/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

	var items = [RSSItem]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// TODO: Rewrite RSSParser for just this case. Sideproject - Rewrite SwiftRSS and maintain it
		let request: NSURLRequest = NSURLRequest(URL: NSURL(string: "https://ipsw.me/updates.rss")!)
		RSSParser.parseFeedForRequest(request, callback: { (feed, error) in
			guard let feed = feed else {
				print(error)
				return
			}
			
			self.items = feed.items
			dispatch_sync(dispatch_get_main_queue(), {
				self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
			})
			
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath)

		let titleLabel = cell.viewWithTag(1000) as! UILabel
		let dateLabel = cell.viewWithTag(1001) as! UILabel
		
		titleLabel.text = items[indexPath.row].title
		
		let dateFormatter = NSDateFormatter()
		// TODO: Localize date (format + timezone)
		dateFormatter.dateFormat = "dd/MM/yyyy"
		
		if let date = items[indexPath.row].pubDate {
			dateLabel.text = dateFormatter.stringFromDate(date)
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
			let index = self.tableView.indexPathForCell((sender as! UITableViewCell))!.row
			destVC.post = items[index]
		}
		
		let backItem = UIBarButtonItem()
		backItem.title = ""
		navigationItem.backBarButtonItem = backItem
	}

}
