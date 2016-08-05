//
//  CurrencyEntity.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation
import CoreData


class CurrencyEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    init(currencyInfo: CurrencyInfo, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = currencyInfo.name
        code = currencyInfo.code
        isFavorite = currencyInfo.isFavorite
        mainRate = currencyInfo.mainRate
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

}
