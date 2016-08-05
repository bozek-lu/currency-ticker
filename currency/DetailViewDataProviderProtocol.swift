//
//  DetailViewDataProviderProtocol.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation

protocol DetailViewDataProviderProtocol {
    weak var delegate: DetailViewDataProviderDelegateProtocol? {get set}
    init(currency: CurrencyEntity, downloadManager: DownloadManagerProtocol, delegate: DetailViewDataProviderDelegateProtocol)
}