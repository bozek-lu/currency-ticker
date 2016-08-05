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
    var currencyValues: [CurrencyDayValue]?
    
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
//        if currency.currencyDayValue?.count == 0 {
//            let defaults = NSUserDefaults.standardUserDefaults()
//            let start = defaults.valueForKey(Const.startDateKey) as? String
//            let end = defaults.valueForKey(Const.endDateKey) as? String
//            if end != nil && start != nil {
//                fetchValues(start!, endDate: end!)
//            }
//            
//            fetchValues(nil, endDate: nil)
//        }
    }
    
    func fetchValues(startDate: String?, endDate: String?) {
        let formetter = Const.queryFormater
        var rangeStartDate: String
        var rangeEndDate: String
        var settingsFetch = false
        
        if startDate != nil && endDate != nil {
            settingsFetch = true
        }
        
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let sixMonthsAgo = calendar.dateByAddingUnit(.Month, value: -6, toDate: NSDate(), options: [])
        
        if startDate != nil {
            rangeStartDate = startDate!
        } else {
            rangeStartDate = sixMonthsAgo!.dateStringWithFormatter(formetter)
        }
        
        if endDate != nil {
            rangeEndDate = endDate!
        } else {
            rangeEndDate = today.dateStringWithFormatter(formetter)
        }
        
        downloadManager!.getCurrencyData(rangeStartDate, to: rangeEndDate, currency: currency!.name!) { (currencyValues, err) in
            if currencyValues != nil {
                var arr: [CurrencyDayValue] = []
                for value in currencyValues! {
                    let dailyValue = CurrencyDayValue(currency: self.currency!, info: value, entity: self.entity, insertIntoManagedObjectContext: self.managedObjectContext)
                    arr.append(dailyValue)
                }
                
                if !arr.isEmpty {
                    self.currencyValues = arr
                    self.delegate?.setupChart(self.currencyValues!, setupFetch: settingsFetch)
                }
                
                do {
                    try self.currency!.managedObjectContext!.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}