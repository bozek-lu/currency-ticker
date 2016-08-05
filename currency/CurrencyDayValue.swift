//
//  CurrencyDayValue.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation
import CoreData


class CurrencyDayValue: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    init(currency: CurrencyEntity, info: CurrencyDayValueInfo, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        date = info.date
        rate = info.rate
        name = info.name
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
