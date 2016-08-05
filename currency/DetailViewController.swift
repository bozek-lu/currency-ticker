//
//  DetailViewController.swift
//  currency
//
//  Created by Łukasz Bożek on 03/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var baseChart: LineChartView!
    
    var dataProvider: DetailViewDataProviderProtocol? {
        didSet {
            
        }
    }
    
    let amountOfPoints = 20

    var detailItem: CurrencyEntity? {
        didSet {
            // Update the view.
            self.dataProvider = DetailViewDataProvider(currency: detailItem!, downloadManager: DownloadManager(), delegate: self)
        }
    }
    
    var currencyValues: [CurrencyDayValue] = []
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DetailViewController: DetailViewDataProviderDelegateProtocol {
    func setupChart(currencyValues: [CurrencyDayValue]) {
        var dataEntries: [BarChartDataEntry] = []
        var datePoints: [String] = []
        
        let iterator = currencyValues.count / amountOfPoints > 0 ? currencyValues.count / amountOfPoints : currencyValues.count
        
        var selectedValues: [CurrencyDayValue] = []
        for i in 0.stride(to: currencyValues.count, by: iterator) {
            selectedValues.append(currencyValues[i])
        }
        
        var i = 0
        for value in selectedValues {
            let date = value.date
            datePoints.append(date!)
            
            let value = currencyValues[i].rate
            let dataEntry = BarChartDataEntry(value: value, xIndex: i)
            dataEntries.append(dataEntry)
            i += 1
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Date")
        let chartData = BarChartData(xVals: datePoints, dataSet: chartDataSet)
        baseChart!.data = chartData
    }
}

