//
//  DownloadManager.swift
//  currency
//
//  Created by Łukasz Bożek on 04/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import UIKit
import Alamofire

//    "EUR=X" "2009-09-11" "2010-03-10"
//    http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote


typealias CurrencyDetailsResponse = ([CurrencyDayValueInfo]?, NSError?) -> Void
typealias CurrencyListResponse = ([CurrencyInfo]?, NSError?) -> Void

struct QueryConst {
    private static let prefix: String = "http://query.yahooapis.com/v1/public/yql?&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=&q="
    private static let symbol = "symbol = "
    private static let andStartDate = "and startDate = "
    private static let andEndDate = "and endDate = "
    private static let selectAllFromHistoricalWhere = "select * from yahoo.finance.historicaldata where "
    private static let allCurrenciesListAddress = "http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json"
}

class DownloadManager: NSObject, DownloadManagerProtocol {
    
    func getCurrencyData(from: String, to: String, currency: String, onCompletion: CurrencyDetailsResponse) -> Void {
//        select * from yahoo.finance.historicaldata where symbol = "EUR=X" and startDate = "2009-09-11" and endDate = "2010-03-10"
        let query = QueryConst.selectAllFromHistoricalWhere + QueryConst.symbol + "\"" + currency + "=X\"" + QueryConst.andStartDate + "\"" + from + "\"" + QueryConst.andEndDate + "\"" + to + "\""
        
        let fixed = QueryConst.prefix + query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        var info: [CurrencyDayValueInfo]?
        Alamofire.request(.GET, fixed)
            .validate()
            .responseJSON { response in
                
                var dict: Dictionary<NSString, AnyObject>?
                var JSONerror: NSError?
                do {
                    dict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary
                    
                    info = self.parseCurrencyDetails(dict!)
                    
                } catch let err as NSError {
                    JSONerror = err
                    print("Error -> \(err)")
                }
                onCompletion(info, JSONerror)
            }
    }
    
    func getAvailableCurrencies(onCompletion: CurrencyListResponse) -> Void {
    
        var list: [CurrencyInfo]?
        Alamofire.request(.GET, QueryConst.allCurrenciesListAddress)
            .validate()
            .responseJSON { response in
                var dict: Dictionary<NSString, AnyObject>?
                var JSONerror: NSError?
                do {
                    dict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary
                    
                    list = self.parseList(dict!)
                    
                } catch let err as NSError {
                    JSONerror = err
                    print("Error -> \(err)")
                }
                 onCompletion(list, JSONerror)
            }
    }
    
    func parseCurrencyDetails(dict: Dictionary<NSString, AnyObject>) -> [CurrencyDayValueInfo] {
        var arr: [CurrencyDayValueInfo] = []
        
        let query = dict["query"]
        if query != nil && query!["count"] as! Int > 0 {
            let results = query!["results"]
            let resources = results!!["quote"] as! NSArray
            for resource in resources {
                let name = resource["Symbol"] as! String
                let date = resource["Date"] as! String
                let rate = (resource["Adj_Close"] as! NSString).doubleValue
                
                arr.append(CurrencyDayValueInfo(name: name, date: date, rate: rate))
            }
        }
        return arr
    }
    
    func parseList(dict: Dictionary<NSString, AnyObject>) -> [CurrencyInfo] {
        let list = dict["list"]
        let resources = list!["resources"] as! NSArray
        
        var arr = [CurrencyInfo]()
        
        for resource in resources {
            let res = resource.valueForKey("resource") as! NSDictionary
            let fields = res.valueForKey("fields") as! NSDictionary
            let code = fields["symbol"] as! String
            
            let name = code[0...2]
            
            let mainRate = (fields["price"] as! NSString).doubleValue
            
            arr.append(CurrencyInfo(name: name, code: code, favorite: false, mainRate: mainRate))
        }
        
        return arr
    }
    
}