//
//  Firmware+CoreDataProperties.swift
//  iFW
//
//  Created by George Dan on 29/03/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Firmware {

    @NSManaged var version: String?
    @NSManaged var buildID: String?
    @NSManaged var releaseDate: NSDate?
    @NSManaged var signed: NSNumber?
    @NSManaged var filename: String?
    @NSManaged var device: Device?

}
