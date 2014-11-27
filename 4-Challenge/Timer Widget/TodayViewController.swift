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
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    preferredContentSize = CGSize(width: CGRectGetWidth(tableView.frame), height: 60.0)
    
    let timerCell = tableView.dequeueReusableCellWithIdentifier("Timer", forIndexPath: indexPath) as TimerCell
    timerCell.delegate = self
    timerCell.timer = Timer(duration: 0)
    
    return timerCell
  }
  
  func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
}

extension TodayViewController: TimerCellDelegate {
  
  func timerCellDidStartTimer(timer: Timer) {
    TimerManager.sharedManager.addTimer(timer)
    println("Did start timer " + timer.uuid)
    if let url = NSURL(string: "timers://start/\(timer.uuid)") {
      extensionContext?.openURL(url, completionHandler: { (handled) -> Void in
        
      })
    }
  }
  
  func timerCellDidStopTimer(timer: Timer) {
    println("Did stop timer " + timer.uuid)
  }
  
  func timerCellDidFinishTimer(timer: Timer) {
    println("Did finish timer " + timer.uuid)
  }
}


