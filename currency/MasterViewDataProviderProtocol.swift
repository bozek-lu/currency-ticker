//
//  MasterViewDataProviderProtocol.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import UIKit

protocol MasterViewDataProviderProtocol: UITableViewDataSource {
    weak var tableView: UITableView? {get set}
    var downloadManager: DownloadManagerProtocol?  {get set}
    func fetchCoreData()
    func fetchWebData()
    func selectedCurrency() -> CurrencyEntity
}