//
//  Extensions.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation
import CoreData

extension NSDate {
    func dateStringWithFormatter(format: String) -> String {
        let formater = NSDateFormatter()
        formater.dateFormat = format
        
        return formater.stringFromDate(self)
    }
}

extension String {
    func dateFromStringWithFormatter(format: String) -> NSDate? {
        let formater = NSDateFormatter()
        formater.dateFormat = format
        
        return formater.dateFromString(self)
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = startIndex.advancedBy(integerRange.startIndex)
        let end = startIndex.advancedBy(integerRange.endIndex)
        let range = start..<end
        return self[range]
    }
}

extension NSManagedObjectContext {
    func deleteAllObjects(error: NSErrorPointer) {
        
        if let entitesByName = persistentStoreCoordinator?.managedObjectModel.entitiesByName {
            
            for (name, entityDescription) in entitesByName {
                deleteAllObjectsForEntity(entityDescription, error: error)
                
                // If there's a problem, bail on the whole operation.
                if error.memory != nil {
                    return
                }
            }
        }
    }
    
    func deleteAllObjectsForEntity(entity: NSEntityDescription, error: NSErrorPointer) {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 50
        
        var fetchResults: [AnyObject] = []
        do {
            fetchResults = try executeFetchRequest(fetchRequest)
        } catch {
            print(error)
        }
        
        if error.memory != nil {
            return
        }
        
        if let managedObjects = fetchResults as? [NSManagedObject] {
            for object in managedObjects {
                deleteObject(object)
            }
        }
    }
}