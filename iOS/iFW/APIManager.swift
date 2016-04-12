//
//  APIManager.swift
//  iFW
//
//  Created by George Dan on 28/03/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import Foundation
import RealmSwift
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
	
	func downloadInfo(callback: (() -> Void)) {
		
		let manager = Manager.sharedInstance
		
		// Specifying the Headers we need
		manager.session.configuration.HTTPAdditionalHeaders = [
			"User-Agent": "iOS/iFW-beta"
		]
		
		manager.request(.GET, "http://ifw-ninjaprawn.rhcloud.com/devices").responseJSON(completionHandler: { response in
			switch response.result {
				case .Success:
					if let value = response.result.value {
						if self.checkSHA(response.data!.sha1.hexString) {
							print("Data is the same! Don't need to do anything")
						} else {
							NSUserDefaults.standardUserDefaults().setObject(response.data!.sha1.hexString, forKey: "devicessha")
							let json = JSON(value)
							
							// First time?
							let realm = try! Realm()
							if !self.shaExists() {
								let devices = Array(json.dictionary!.keys)
								
								for device in devices {
									let newDevice = Device()
									
									newDevice.deviceID = device
									newDevice.deviceCode = json[device]["BoardConfig"].stringValue
									newDevice.deviceName = json[device]["name"].stringValue
									
									try! realm.write {
										realm.add(newDevice)
									}
									
									for firmware in json[device]["firmwares"].array! {
										let newFirmware = Firmware()
										
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
										
										try! realm.write {
											realm.add(newFirmware)
											newDevice.firmwares.append(newFirmware)
										}

									}
								}
							// Exists!
							} else {
								
								// Ayy 1 loop
								
								let devices = Array(json.dictionary!.keys)
								
								for device in devices {
									let storedDevices = realm.objects(Device).filter("deviceID = '\(device)'")
									if storedDevices.count > 0 {
										let currentDevice = storedDevices[0]
										try! realm.write {
											currentDevice.deviceName = json[currentDevice.deviceID]["name"].stringValue
										}
										
										let firmwares = json[currentDevice.deviceID]["firmwares"].array!
										
										for firmware in firmwares {
											let storedFirmwares = realm.objects(Firmware).filter("device.deviceID = '\(currentDevice.deviceID)' AND version = '\(firmware["version"].stringValue)'")
											if storedFirmwares.count > 0 {
												try! realm.write {
													storedFirmwares[0].signed = firmware["signed"].boolValue
													storedFirmwares[0].filename = firmware["filename"].stringValue
												}
											} else {
												let newFirmware = Firmware()
												
												newFirmware.device = currentDevice
												newFirmware.buildID = firmware["buildid"].stringValue
												newFirmware.version = firmware["version"].stringValue
												newFirmware.filename = firmware["filename"].stringValue
												newFirmware.signed = firmware["signed"].boolValue
												let stringDate = firmware["releasedate"].stringValue
												
												let dateFormatter = NSDateFormatter()
												dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
												dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
												
												newFirmware.releaseDate = dateFormatter.dateFromString(stringDate)
												
												try! realm.write {
													realm.add(newFirmware)
													currentDevice.firmwares.append(newFirmware)
												}
											}
										}
									} else {
										let newDevice = Device()
										
										newDevice.deviceID = device
										newDevice.deviceCode = json[device]["BoardConfig"].stringValue
										newDevice.deviceName = json[device]["name"].stringValue
										
										try! realm.write {
											realm.add(newDevice)
										}
										
										for firmware in json[device]["firmwares"].array! {
											let newFirmware = Firmware()
											
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
											
											try! realm.write {
												realm.add(newFirmware)
												newDevice.firmwares.append(newFirmware)
											}
										}
									}
								}
							}
						}
					}

				case .Failure(_):
					debugPrint(response)
			}
			callback()
		})
		
	}
	
	func checkSHA(sha: String) -> Bool {
		if let storedSHA = NSUserDefaults.standardUserDefaults().stringForKey("devicessha") {
			if storedSHA == sha {
				return true
			}
		}
		return false
	}
	
	func shaExists() -> Bool {
		guard NSUserDefaults.standardUserDefaults().stringForKey("devicessha") != nil else {
			return false
		}
		return true
	}
	
}