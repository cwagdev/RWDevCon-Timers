//
//  TimerCell.swift
//  Timers
//
//  Created by Chris Wagner on 11/24/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import TimerKit

public protocol TimerCellDelegate {
  func timerCellDidStartTimer(timer: Timer)
  func timerCellDidStopTimer(timer: Timer)
  func timerCellDidFinishTimer(timer: Timer)
}

public class TimerCell: UITableViewCell {
  
  @IBOutlet weak var durationStepper: UIStepper!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var startStopButton: UIButton!
  
  public var delegate: TimerCellDelegate?
  
  public var timer: Timer? {
    didSet {
      if let timer = timer {
        timer.tickBlock = tickBlock
        updateDurationLabel()
        if timer.inProgress == true {
          startStopButton.setTitle(NSLocalizedString("Stop", comment: "Stop timer button"), forState: .Normal)
          durationStepper.hidden = true
        }
      }
    }
  }
  
  lazy private var tickBlock: (Timer -> Void) = { timer in
    println("Remaining: \(timer.duration - timer.elapsed)")
    self.updateDurationLabel()
    if timer.expired == true {
      self.durationLabel.text = NSLocalizedString("Finished", comment: "Timer ended string")
      self.startStopButton.setTitle(NSLocalizedString("Start", comment: "Start timer button"), forState: .Normal)
      self.durationStepper.hidden = false
      self.durationStepper.value = 0
      self.delegate?.timerCellDidFinishTimer(timer)
    }
  }
  
  public required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    timer?.tickBlock = tickBlock
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    updateDurationLabel()
  }
  
  @IBAction public func durationStepperValueChanged(stepper: UIStepper) {    
    if timer?.inProgress != true {
      timer?.duration = stepper.value
      updateDurationLabel()
    }
  }
  
  @IBAction public func startOrStop(button: UIButton) {
    if let timer = timer {
      if timer.inProgress == true {
        button.setTitle(NSLocalizedString("Start", comment: "Start timer button"), forState: .Normal)
        timer.stop()
        durationStepper.hidden = false
        delegate?.timerCellDidStopTimer(timer)
      } else {
        durationStepper.hidden = true
        timer.start()
        delegate?.timerCellDidStartTimer(timer)
        button.setTitle(NSLocalizedString("Stop", comment: "Stop timer button"), forState: .Normal)
      }
    }
  }
  
  private func updateDurationLabel() {
    durationLabel.text = timer?.remainingDuration()
  }
}

public class AddTimerCell: UITableViewCell {
    
    @IBOutlet public weak var addTimerLabel: UILabel!
    
}