//
//  DownloadManagerProtocol.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation

protocol DownloadManagerProtocol {
    func getCurrencyData(from: String, to: String, currency: String, onCompletion: CurrencyDetailsResponse) -> Void
    func getAvailableCurrencies(onCompletion: CurrencyListResponse) -> Void 
}