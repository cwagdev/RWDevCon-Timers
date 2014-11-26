//
//  ViewController.swift
//  Timers
//
//  Created by Chris Wagner on 11/20/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import TimerKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TimerManager.sharedManager.timers.count + 5
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    
    let numberOfRows = tableView.numberOfRowsInSection(indexPath.section)
    if lastRow(indexPath.row, numberOfRows: numberOfRows) == true {
      cell = tableView.dequeueReusableCellWithIdentifier("AddTimer", forIndexPath: indexPath) as AddTimerCell
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier("Timer", forIndexPath: indexPath) as TimerCell
    }
    
    return cell!
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if lastRow(indexPath.row, numberOfRows: tableView.numberOfRowsInSection(indexPath.section)) == true {
      println("Add a timer")
    }
  }
  
  func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return lastRow(indexPath.row, numberOfRows: tableView.numberOfRowsInSection(indexPath.section))
  }
  
  func lastRow(row: Int, numberOfRows: Int) -> Bool {
    if row < numberOfRows-1 {
      return false
    } else {
      return true
    }
  }
}