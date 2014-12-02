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
  
  @IBOutlet weak var durationLabel: UILabel!
  private var timer = Timer(duration: 0)
  
  private let dateComponents: NSDateComponents = {
    let components = NSDateComponents()
    components.minute = 0
    
    return components
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.preferredContentSize = CGSizeMake(0, 60)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    timer = Timer(duration: 0)
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
  
  @IBAction func start(sender: UIButton) {
    TimerManager.sharedManager.addTimer(timer)
    if let url = NSURL(string: "timers://start/\(timer.uuid)") {
      extensionContext?.openURL(url, completionHandler: { (handled) -> Void in
        
      })
    }
  }
  
  @IBAction func stepperValueChanged(stepper: UIStepper) {
    timer.duration = stepper.value
    updateDurationLabel()
  }
  
  private func updateDurationLabel() {
    durationLabel.text = timer.remainingDuration()
  }
  
}

