//
//  TimerCell.swift
//  Timers
//
//  Created by Chris Wagner on 11/24/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import TimerKit

public class TimerCell: UITableViewCell {
  
  @IBOutlet weak var durationStepper: UIStepper!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var startStopButton: UIButton!
  
  public var timer: Timer {
    didSet {
      timer.tickBlock = tickBlock
    }
  }
  
  private let durationFormatter: NSDateComponentsFormatter = {
    let formatter = NSDateComponentsFormatter()
    formatter.unitsStyle = .Short
    return formatter
    }()
  
  private let dateComponents: NSDateComponents = {
    let components = NSDateComponents()
    components.minute = 0
    
    return components
    }()
  
  lazy private var tickBlock: (Timer -> Void) = { timer in
    println("Remaining: \(timer.duration - timer.elapsed)")
    self.updateDurationLabel()
    if timer.expired == true {
      self.durationLabel.text = NSLocalizedString("Finished", comment: "Timer ended string")
      self.startStopButton.setTitle(NSLocalizedString("Start", comment: "Start timer button"), forState: .Normal)
      self.durationStepper.hidden = false
      self.durationStepper.value = 0
    }
  }
  
  public required init(coder aDecoder: NSCoder) {
    timer = Timer(duration: 0)
    
    super.init(coder: aDecoder)
    
    timer.tickBlock = tickBlock
    
    TimerManager.sharedManager.addTimer(timer)
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    updateDurationLabel()
  }
  
  @IBAction public func durationStepperValueChanged(stepper: UIStepper) {
    
    if timer.inProgress != true {
      timer.duration = stepper.value
      updateDurationLabel()
    }
  }
  
  @IBAction public func startOrStop(button: UIButton) {
    if timer.inProgress == true {
      button.setTitle(NSLocalizedString("Start", comment: "Start timer button"), forState: .Normal)
      timer.stop()
      durationStepper.hidden = false
    } else {
      durationStepper.hidden = true
      timer.start()
      button.setTitle(NSLocalizedString("Stop", comment: "Stop timer button"), forState: .Normal)
    }
  }
  
  private func updateDurationLabel() {
    let hourAndMinutes = timer.durationInHoursAndMinutes()
    dateComponents.hour = hourAndMinutes.hours
    dateComponents.minute = hourAndMinutes.minutes
    
    durationLabel.text = durationFormatter.stringFromDateComponents(dateComponents)
  }
}