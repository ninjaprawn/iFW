//
//  Firmware.swift
//  iFW
//
//  Created by George Dan on 7/04/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import Foundation
import RealmSwift

class Firmware: Object {
    
	/*
	@NSManaged var version: String?
	@NSManaged var buildID: String?
	@NSManaged var releaseDate: NSDate?
	@NSManaged var signed: NSNumber?
	@NSManaged var filename: String?
	@NSManaged var device: Device?
	*/
	
	dynamic var buildID = ""
	dynamic var filename = ""
	dynamic var releaseDate: NSDate?
	dynamic var signed = false
	dynamic var version = ""
	
	dynamic var device: Device?
	
}
