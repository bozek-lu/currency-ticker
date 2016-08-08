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
    @IBOutlet weak var selectedRangeChart: LineChartView!
    var savedDate: String?
    var dataProvider: DetailViewDataProviderProtocol?
    
    let amountOfPoints = 10
    
    let progressHUD = ProgressHUD(text: "Loading...")

    var detailItem: CurrencyEntity? {
        didSet {
            // Update the view.
            self.navigationItem.title = detailItem?.name
            self.dataProvider = DetailViewDataProvider(currency: detailItem!, downloadManager: DownloadManager(), delegate: self)
        }
    }
    
    var currencyValues: [CurrencyDayValue] = []
    
    
    override func viewDidAppear(animated: Bool) {
        
        if detailItem != nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            let start = defaults.valueForKey(Const.startDateKey) as? String
            let end = defaults.valueForKey(Const.endDateKey) as? String
            
            if savedDate != nil && start != nil && savedDate! == start! {
                return
            } else {
                savedDate = start
            }
            
            self.view.addSubview(progressHUD)
            
            if end != nil && start != nil {
                dataProvider?.fetchValues(start!, endDate: end!)
            }
            
            dataProvider?.fetchValues(nil, endDate: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let userDefault = NSUserDefaults.standardUserDefaults()
        let range = userDefault.valueForKey(Const.startDateKey) != nil
        self.selectedRangeChart.noDataText = range ? "No data for currency in this range" : "Select range in settings to see chart"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DetailViewController: DetailViewDataProviderDelegateProtocol {
    func setupChart(currencyValues: [CurrencyDayValue], setupFetch: Bool) {
        
        baseChart.xAxis.labelPosition = .Bottom
        selectedRangeChart.xAxis.labelPosition = .Bottom
        baseChart.descriptionText = ""
        selectedRangeChart.descriptionText = ""
        
        var dataEntries: [ChartDataEntry] = []
        var datePoints: [String] = []
        
        let iterator = currencyValues.count / amountOfPoints > 0 ? currencyValues.count / amountOfPoints : currencyValues.count
        
        var selectedValues: [CurrencyDayValue] = []
        for i in 0.stride(to: currencyValues.count, by: iterator) {
            selectedValues.append(currencyValues[i])
        }
        
        var i = 0
        selectedValues = selectedValues.reverse()
        for value in selectedValues {
            let date = value.date
            datePoints.append(date!)
            
            let value = currencyValues[i].rate
            let dataEntry = ChartDataEntry(value: value, xIndex: i)
            dataEntries.append(dataEntry)
            i += 1
        }
        
        let text = setupFetch ? "Value change in year you selected" : "Currency value change over last 6 months"
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: text)
        
        let chartData = LineChartData(xVals: datePoints, dataSet: chartDataSet)
        if setupFetch {
            selectedRangeChart!.data = chartData
            selectedRangeChart.animate(xAxisDuration: 2)
        } else {
            baseChart!.data = chartData
            baseChart.animate(xAxisDuration: 2)
        }
        
        progressHUD.removeFromSuperview()
    }
}

