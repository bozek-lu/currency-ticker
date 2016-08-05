//
//  DetailViewDataProvider.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import UIKit
import CoreData
import Charts

class DetailViewDataProvider: NSObject, DetailViewDataProviderProtocol {
    weak var currency: CurrencyEntity?
    weak var delegate: DetailViewDataProviderDelegateProtocol?
    var currencyValues: [CurrencyDayValue]? {
        didSet {
            delegate?.setupChart(currencyValues!)
        }
    }
    
    var downloadManager: DownloadManagerProtocol?
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    lazy var entity: NSEntityDescription = {
        NSEntityDescription.entityForName("CurrencyDayValue", inManagedObjectContext: self.managedObjectContext)
        }()!
    
    required init(currency: CurrencyEntity, downloadManager: DownloadManagerProtocol, delegate: DetailViewDataProviderDelegateProtocol) {
        super.init()
        self.delegate = delegate
        self.currency = currency
        self.downloadManager = downloadManager
        if currency.currencyDayValue?.count == 0 {
            fetchValues()
        }
    }
    
    func fetchValues() {
        
        let rangeStartDate = "2009-09-11"
        let rangeEndDate = "2010-03-10"
        
        downloadManager!.getCurrencyData(rangeStartDate, to: rangeEndDate, currency: currency!.name!) { (currencyValues, err) in
            if currencyValues != nil {
                var arr: [CurrencyDayValue] = []
                for value in currencyValues! {
                    let dailyValue = CurrencyDayValue(currency: self.currency!, info: value, entity: self.entity, insertIntoManagedObjectContext: self.managedObjectContext)
                    arr.append(dailyValue)
                }
                
                self.currencyValues = arr
                
                do {
                    try self.currency!.managedObjectContext!.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}