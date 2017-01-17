//
//  RawPredictionMO.swift
//  Traveler
//
//  Created by YED on 06/01/17.
//  Copyright © 2017 YED. All rights reserved.
//

import UIKit
import CoreData

class RawPredictions_20: NSManagedObject {
    
    @NSManaged var mode: String?
    @NSManaged var datetime: NSDate?

}

class RawPredictions_40: NSManagedObject {
    
    @NSManaged var mode: String?
    @NSManaged var datetime: NSDate?
    
}

class RawPredictions_60: NSManagedObject {
    
    @NSManaged var mode: String?
    @NSManaged var datetime: NSDate?
    
}

class Buffer: NSManagedObject {
    
    @NSManaged var mode: String?
    @NSManaged var datetime: NSDate?
    
}
