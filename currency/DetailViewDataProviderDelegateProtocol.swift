//
//  DetailViewDataProviderDelegateProtocol.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation

protocol DetailViewDataProviderDelegateProtocol: class {
    func setupChart(currencyValues: [CurrencyDayValue], setupFetch: Bool)
}