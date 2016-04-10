//
//  Device.swift
//  iFW
//
//  Created by George Dan on 7/04/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import Foundation
import RealmSwift

class Device: Object {
	
	dynamic var deviceCode = ""
	dynamic var deviceID = ""
	dynamic var deviceName = ""
	
	let firmwares = List<Firmware>()

}
