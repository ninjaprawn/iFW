//
//  Device+CoreDataProperties.swift
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

extension Device {

    @NSManaged var deviceCode: String?
    @NSManaged var name: String?
    @NSManaged var deviceID: String?
    @NSManaged var firmwares: NSSet?

}
