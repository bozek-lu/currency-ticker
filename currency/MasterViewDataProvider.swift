//
//  MasterViewDataProvider.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class MasterViewDataProvider: NSObject, MasterViewDataProviderProtocol {
    
    weak var tableView: UITableView? {
        didSet {
            tableView!.dataSource = self
        }
    }
    
    var currencies: [CurrencyEntity] = []
    var downloadManager: DownloadManagerProtocol?
    let cellIdentifier = "Cell"
    var fetchingInProgress = false
    
    //TODO: dependency injection
    lazy var managedObjectContext : NSManagedObjectContext = {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    lazy var entity: NSEntityDescription = {
        NSEntityDescription.entityForName("CurrencyEntity", inManagedObjectContext: self.managedObjectContext)
        }()!
    
    
    func fetchCoreData() {
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        do {
            try currencies = managedObjectContext.executeFetchRequest(fetchRequest) as! [CurrencyEntity]
        } catch {
            print(error)
        }
    }

    func fetchWebData() {
        downloadManager?.getAvailableCurrencies({ (currencyList, err) in
            if currencyList != nil && !currencyList!.isEmpty {
                for currency in currencyList! {
                    let currency = CurrencyEntity(currencyInfo: currency, entity: self.entity, insertIntoManagedObjectContext: self.managedObjectContext)
                    self.currencies.append(currency)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView?.reloadData()
                }
            }
        })
    }
    
    func selectedCurrency() -> CurrencyEntity {
        let currency = currencies[tableView!.indexPathForSelectedRow!.row]
        return currency
    }
    
}

//MARK: UITableViewDataSource
extension MasterViewDataProvider: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier(cellIdentifier)
        let currency = currencies[indexPath.row]
        
        cell?.textLabel?.text = currency.name! + " " + "\(currency.mainRate)"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currencies.count
    }
}