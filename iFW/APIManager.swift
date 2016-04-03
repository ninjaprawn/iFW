//
//  APIManager.swift
//  iFW
//
//  Created by George Dan on 28/03/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

extension NSData {
	
	// Converting NSData to Hex string from http://stackoverflow.com/questions/7520615/how-to-convert-an-nsdata-into-an-nsstring-hex-string/7520655#7520655
	var hexString : String {
		let buf = UnsafePointer<UInt8>(bytes)
		let charA = UInt8(UnicodeScalar("a").value)
		let char0 = UInt8(UnicodeScalar("0").value)
		
		func itoh(i: UInt8) -> UInt8 {
			return (i > 9) ? (charA + i - 10) : (char0 + i)
		}
		
		let p = UnsafeMutablePointer<UInt8>.alloc(length * 2)
		
		for i in 0..<length {
			p[i*2] = itoh((buf[i] >> 4) & 0xF)
			p[i*2+1] = itoh(buf[i] & 0xF)
		}
		
		return String(NSString(bytesNoCopy: p, length: length*2, encoding: NSUTF8StringEncoding, freeWhenDone: true)!)
	}
	
	// SHA1 of NSData modified from https://gist.github.com/jstn/d2c6ade1f2ad8bae6f57
	var sha1 : NSData {
		let result = NSMutableData(length: Int(CC_SHA1_DIGEST_LENGTH))!
		CC_SHA1(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(result.mutableBytes))
		return NSData(data: result)
	}
}

class APIManager {
	
	func downloadInfo() {
		
		let manager = Manager.sharedInstance
		
		// Specifying the Headers we need
		manager.session.configuration.HTTPAdditionalHeaders = [
			"User-Agent": "iOS/iFW-1.0b1"
		]
		
		manager.request(.GET, "https://api.ipsw.me/v2.1/firmwares.json/condensed").responseJSON(completionHandler: { response in
			switch response.result {
				case .Success:
					if let value = response.result.value {
						if !self.checkSHA(response.data!.sha1.hexString) {
							print("Data is the same! Don't need to do anything")
						} else {
							NSUserDefaults.standardUserDefaults().setObject(response.data!.sha1.hexString, forKey: "firmwares.json.sha1")
							let json = JSON(value)
							
							// First time?
							if !self.shaExists() {
								let devices = Array(json["devices"].dictionary!.keys)
								
								// TODO: Better CoreData Management
								for device in devices {
									let newDevice = NSEntityDescription.insertNewObjectForEntityForName("Device", inManagedObjectContext: CDManager.sharedManager.managedObjectContext!) as! Device
									
									newDevice.deviceID = device
									newDevice.deviceCode = json["devices"][device]["BoardConfig"].stringValue
									newDevice.name = json["devices"][device]["name"].stringValue
									
									for firmware in json["devices"][device]["firmwares"].array! {
										let newFirmware = NSEntityDescription.insertNewObjectForEntityForName("Firmware", inManagedObjectContext: CDManager.sharedManager.managedObjectContext!) as! Firmware
										
										newFirmware.device = newDevice
										newFirmware.buildID = firmware["buildid"].stringValue
										newFirmware.version = firmware["version"].stringValue
										newFirmware.filename = firmware["filename"].stringValue
										newFirmware.signed = firmware["signed"].boolValue
										let stringDate = firmware["releasedate"].stringValue
										
										let dateFormatter = NSDateFormatter()
										dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
										dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
										
										newFirmware.releaseDate = dateFormatter.dateFromString(stringDate)
										
										CDManager.sharedManager.saveCoreData(nil)
									}
								}
							// Exists!
							} else {
								let cdDevices = CDManager.sharedManager.fetchedResultsController.fetchedObjects as! [Device]
								for device in cdDevices {
									device.name = json["devices"][device.deviceID!]["name"].stringValue
									
									let firmwares = json["devices"][device.deviceID!]["firmwares"].array!
									// BuildID : {version: "X.X", releasedate: "yyyy-MM-dd'T'HH:mm:ss'Z'", signed: bool, filename: "blah.ipsw"}
									var formattedFirmwares = Dictionary<String, Dictionary<String, AnyObject>>()
									
									for firmware in firmwares {
										var currentFirmware = Dictionary<String, AnyObject>()
										currentFirmware["version"] = firmware["version"].stringValue
										currentFirmware["filename"] = firmware["filename"].stringValue
										currentFirmware["releasedate"] = firmware["releasedate"].stringValue
										currentFirmware["signed"] = firmware["signed"].boolValue
										
										formattedFirmwares[firmware["buildid"].stringValue] = currentFirmware
									}
									
									// Oops, another loop????
									// Also consistency pls with brackets and <>
									for firmware in device.firmwares?.allObjects as! [Device] {
										
									}
									
									CDManager.sharedManager.saveCoreData(nil)
								}
							}
						}
					}
				case .Failure(_):
					debugPrint(response)
			}
			print("Finished!")
		})
		
	}
	
	func checkSHA(sha: String) -> Bool {
		if let storedSHA = NSUserDefaults.standardUserDefaults().stringForKey("firmwares.json.sha1") {
			if storedSHA == sha {
				return true
			}
		}
		return false
	}
	
	func shaExists() -> Bool {
		guard NSUserDefaults.standardUserDefaults().stringForKey("firmwares.json.sha1") != nil else {
			return false
		}
		return true
	}
	
}