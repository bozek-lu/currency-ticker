//
//  CurrencyInfo.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation

struct CurrencyInfo {
    var isFavorite: Bool
    let name: String
    var code: String?
    var mainRate: Double
    
    init(name: String, code: String?, favorite: Bool, mainRate: Double) {
        self.name = name
        self.code = code
        self.isFavorite = favorite
        self.mainRate = mainRate
    }
}