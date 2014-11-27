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
  
  override func viewWillAppear(animated: Bool) {
    tableView.reloadData()
  }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TimerManager.sharedManager.timers.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    
    let numberOfRows = tableView.numberOfRowsInSection(indexPath.section)
    if lastRow(indexPath.row, numberOfRows: numberOfRows) == true {
      cell = tableView.dequeueReusableCellWithIdentifier("AddTimer", forIndexPath: indexPath) as AddTimerCell
    } else {
      let timerCell = tableView.dequeueReusableCellWithIdentifier("Timer", forIndexPath: indexPath) as TimerCell
      timerCell.delegate = self
      timerCell.timer = TimerManager.sharedManager.timers[indexPath.row]
      cell = timerCell
    }
    
    return cell!
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if lastRow(indexPath.row, numberOfRows: tableView.numberOfRowsInSection(indexPath.section)) == true {
      tableView.beginUpdates()
      tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
      TimerManager.sharedManager.addTimer(Timer(duration: 0))
      tableView.endUpdates()
    }
  }
  
  func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return lastRow(indexPath.row, numberOfRows: tableView.numberOfRowsInSection(indexPath.section))
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if !lastRow(indexPath.row, numberOfRows: tableView.numberOfRowsInSection(indexPath.section)) {
      return true
    } else {
      return false
    }
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let timerCell = tableView.cellForRowAtIndexPath(indexPath) as TimerCell
      if let timer = timerCell.timer {
        TimerManager.sharedManager.removeTimer(timer)
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        tableView.endUpdates()
      }
    }
  }
  
  func lastRow(row: Int, numberOfRows: Int) -> Bool {
    if row < numberOfRows-1 {
      return false
    } else {
      return true
    }
  }
}

extension ViewController: TimerCellDelegate {
  
  func timerCellDidStartTimer(timer: Timer) {
    println("Did start timer " + timer.uuid)
    LocalNotificationHelper.scheduleNotification(forTimer: timer)
  }
  
  func timerCellDidStopTimer(timer: Timer) {
    println("Did stop timer " + timer.uuid)
    LocalNotificationHelper.cancelNotification(forTimer: timer)
  }
  
  func timerCellDidFinishTimer(timer: Timer) {
    println("Did finish timer " + timer.uuid)
  }
}