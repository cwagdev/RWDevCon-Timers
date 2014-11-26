//
//  TodayViewController.swift
//  Timer Widget
//
//  Created by Chris Wagner on 11/25/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import NotificationCenter
import TimerKit

class TodayViewController: UIViewController, NCWidgetProviding {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view from its nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.NewData)
  }
  
  func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsetsZero
  }
  
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = TimerManager.sharedManager.timers.count + 1
    preferredContentSize = CGSize(width: CGRectGetWidth(tableView.frame), height: CGFloat(numberOfRows * 60))
    return numberOfRows
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

extension TodayViewController: TimerCellDelegate {
  
  func timerCellDidStartTimer(timer: Timer) {
    println("Did start timer " + timer.uuid)
//    extensionContext?.openURL(<#URL: NSURL#>, completionHandler: <#((Bool) -> Void)?##(Bool) -> Void#>)
//    LocalNotificationHelper.scheduleNotification(forTimer: timer)
  }
  
  func timerCellDidStopTimer(timer: Timer) {
    println("Did stop timer " + timer.uuid)
//    LocalNotificationHelper.cancelNotification(forTimer: timer)
  }
  
  func timerCellDidFinishTimer(timer: Timer) {
    println("Did finish timer " + timer.uuid)
  }
}


