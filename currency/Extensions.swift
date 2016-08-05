//
//  Extensions.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation

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
}