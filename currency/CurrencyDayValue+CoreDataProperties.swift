//
//  CurrencyDayValue+CoreDataProperties.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CurrencyDayValue {

    @NSManaged var date: String?
    @NSManaged var name: String?
    @NSManaged var rate: Double
    @NSManaged var currencyEntity: CurrencyEntity?

}
