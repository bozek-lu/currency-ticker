//
//  CurrencyDayValueInfo.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation

struct CurrencyDayValueInfo {
    var name: String?
    var date: String
    var rate: Double
    
    init(name: String, date: String, rate: Double) {
        self.name = name
        self.date = date
        self.rate = rate
    }
}

