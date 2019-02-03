//
//  Steps+CoreDataProperties.swift
//  pedometer
//
//  Created by Fitz on 2019/1/31.
//  Copyright © 2019年 Facebook. All rights reserved.
//
//

import Foundation
import CoreData


extension Steps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Steps> {
        return NSFetchRequest<Steps>(entityName: "Steps")
    }

    @NSManaged public var steps: Double

}
