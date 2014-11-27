//
//  TimerManager.swift
//  Timers
//
//  Created by Chris Wagner on 11/21/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit

private let AppGroupName = "group.com.raywenderlich.timers"
private let TimersUserDefaultsKey = "TimersUserDefaultsKey"
private let _sharedManager = TimerManager()

public class TimerManager {
  
  lazy public private(set) var timers: [Timer] = {
    let defaults = NSUserDefaults(suiteName: AppGroupName)
    if let timers = defaults?.arrayForKey(TimersUserDefaultsKey) as? [Timer] {
      return timers
    } else {
      return [Timer]()
    }
  }()
  
  private var runLoopTimer: NSTimer!
  
  private init() {
    self.runLoopTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "tickAllTimers:", userInfo: nil, repeats: true)
  }
  
  public class var sharedManager: TimerManager {
    return _sharedManager
  }
  
  public func addTimer(timer: Timer) {
    timers.append(timer)
  }
  
  public func removeTimer(timer: Timer) {
    if let timerIndex = find(timers, timer) {
      timers.removeAtIndex(timerIndex)
    }
  }
  
  @objc public func tickAllTimers(timer: NSTimer) {
    for timer in timers {
      if timer.inProgress == true {
        timer.tick()
      }
    }
  }
}