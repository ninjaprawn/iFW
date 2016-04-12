//
//  Swift+Dates.swift
//  iFW
//
//  Created by George Dan on 12/04/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import Foundation

extension String {
	
	func fixDate() -> String {
		var new = ""
		let components = self.componentsSeparatedByString("/")
		
		for component in components {
			if component.characters.count != 1 {
				new += "\(component)/"
			} else {
				new += "0\(component)/"
			}
		}
		
		return String(new.characters.dropLast())
	}
	
}