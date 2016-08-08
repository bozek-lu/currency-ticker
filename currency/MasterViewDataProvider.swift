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
    
    var favorites: Bool = true {
        didSet {
            tableView?.reloadData()
        }
    }
    var currencies: [CurrencyEntity] = []
    var downloadManager: DownloadManagerProtocol?
    let cellIdentifier = "Cell"
    
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
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView?.reloadData()
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
    
    func refreshEverything() {
        currencies = []
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView?.reloadData()
        }
    }
}

//MARK: UITableViewDataSource
extension MasterViewDataProvider: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView?.dequeueReusableCellWithIdentifier(cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier:cellIdentifier)
        }

        let currency = favorites ? currencies.filter { $0.isFavorite == true }[indexPath.row] : currencies[indexPath.row]
        
        cell!.textLabel?.text = currency.name! + " " + "\(currency.mainRate)"
        if currency.isFavorite && !favorites {
            cell?.backgroundColor = UIColor.cyanColor()
        } else {
            cell?.backgroundColor = UIColor.clearColor()
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currencies.count == 0 {
            fetchWebData()
        }
        
        return favorites ? currencies.filter { $0.isFavorite == true }.count : currencies.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {
            currencies.filter { $0.isFavorite == true }[indexPath.row].isFavorite = false
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            currencies[indexPath.row].isFavorite = true
        }
    }
}