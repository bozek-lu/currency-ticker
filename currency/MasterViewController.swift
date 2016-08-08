//
//  MasterViewController.swift
//  currency
//
//  Created by Łukasz Bożek on 03/08/16.
//  Copyright © 2016 Łukasz Bożek. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var dataProvider: MasterViewDataProviderProtocol?
    var favorites = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupController()
        setupDataProvider()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let str = defaults.valueForKey(Const.reloadDataKey) as? Bool
        
        if str != nil {
            dataProvider?.refreshEverything()
            defaults.removeObjectForKey(Const.reloadDataKey)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDataProvider() {
        dataProvider = MasterViewDataProvider()
        let downloadManager = DownloadManager()
        dataProvider!.downloadManager = downloadManager
        dataProvider?.tableView = self.tableView
        dataProvider?.fetchCoreData()
    }
    
    func setupController() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let changeButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action:  #selector(changeList(_:)))
        navigationItem.rightBarButtonItem = changeButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    func changeList(sender: AnyObject) {
        changeBarButtons()
        self.navigationItem.title = favorites ? "Favorites" : "All"
    }
    
    func changeBarButtons() {
        if favorites {
            let changeButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(changeList(_:)))
            self.navigationItem.rightBarButtonItem = changeButton
        } else {
            let changeButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action:  #selector(changeList(_:)))
            navigationItem.rightBarButtonItem = changeButton
        }
        
        favorites = !favorites
        dataProvider?.favorites = favorites
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Const.masterToDetailSegueIdentifier {
            if self.tableView.indexPathForSelectedRow != nil {
                let object = dataProvider!.selectedCurrency()
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Const.masterToDetailSegueIdentifier, sender: self)
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.whiteColor()
        header.textLabel?.textColor = UIColor.grayColor()
        header.textLabel?.font = UIFont.systemFontOfSize(12)
        header.textLabel?.text = "Currency value based on USD"
        header.textLabel?.textAlignment = .Center
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return favorites ? .Delete : .Insert
    }
}
