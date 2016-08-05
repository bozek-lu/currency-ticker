//
//  SettingsViewController.swift
//  currency
//
//  Created by Łukasz Bożek on 05/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import UIKit
import CoreData
import DatePickerDialog

class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var iteratorTextField: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let numberToolbar: UIToolbar = UIToolbar()
    
    override func viewWillAppear(animated: Bool) {
        let start = defaults.valueForKey(Const.startDateKey) as? String
        let iterator = defaults.valueForKey(Const.iteratorKey) as? Int
        
        if start != nil {
            startDate.text = start![0...3]
        }
        
        if iterator != nil {
            iteratorTextField.text = "\(iterator!)"
        } else {
            defaults.setInteger(10, forKey: Const.iteratorKey)
            iteratorTextField.text = "\(10)"
        }
    }
    
    override func viewDidLoad() {
        setupTextField()
    }
    
    @IBAction func clearData(sender: AnyObject) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        context.performBlock {
            var error: NSError?
            context.deleteAllObjects(&error)
            
            if error == nil {
                context.performBlockAndWait {
                    do {
                        try context.save()
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setBool(true, forKey: Const.reloadDataKey)
                    } catch {
                        print("Error deleting all objects: \(error)")
                    }
                }
            }
            
            if let error = error {
                print("Error deleting all objects: \(error)")
            }
        }
    }
    
    @IBAction func editStartDate(sender: AnyObject) {
        DatePickerDialog().show("Select a year", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            if date != nil {
                let str = date?.dateStringWithFormatter(Const.queryFormater)
                self.saveStartDate(str!)
            }
        }
    }
    
    @IBAction func editAmountOfPoints(sender: AnyObject) {
        
    }
    
    func setupTextField() {
        iteratorTextField.delegate = self
        numberToolbar.barTintColor = UIColor.grayColor()
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SettingsViewController.cancel)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SettingsViewController.save))
        ]
        
        numberToolbar.sizeToFit()
        
        iteratorTextField.inputAccessoryView = numberToolbar
    }
    
    func cancel() {
        iteratorTextField.resignFirstResponder()
        iteratorTextField.text = "\(defaults.valueForKey(Const.iteratorKey) as! Int)"
    }
    
    func save() {
        iteratorTextField.resignFirstResponder()
        let int = Int(iteratorTextField.text!)
        defaults.setInteger(int!, forKey: Const.iteratorKey)
    }
    
    func saveStartDate(date: String) {
        let startPostfix = "-01-01"
        let endPostfix = "-12-31"
        let prefix = date[0...3]
        let start = prefix + startPostfix
        let end = prefix + endPostfix
        
        defaults.setValue(start, forKeyPath: Const.startDateKey)
        defaults.setValue(end, forKeyPath: Const.endDateKey)
        startDate.text = prefix
    }

}