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
    return self.loadPersistedTimers()
  }()
  
  private var runLoopTimer: NSTimer!
  private var tickCount = 0
  
  private init() {
    self.runLoopTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "tickAllTimers:", userInfo: nil, repeats: true)
  }
  
  public class var sharedManager: TimerManager {
    return _sharedManager
  }
  
  public func addTimer(timer: Timer) {
    timers.append(timer)
    persistTimers()
  }
  
  public func removeTimer(timer: Timer) {
    if let timerIndex = find(timers, timer) {
      timers.removeAtIndex(timerIndex)
      persistTimers()
    }
  }
  
  public func timer(forUUID uuid: String) -> Timer? {
    for timer in timers {
      if timer.uuid == uuid {
        return timer
      }
    }
    
    return nil
  }
  
  @objc public func tickAllTimers(timer: NSTimer) {
    for timer in timers {
      if timer.inProgress == true {
        timer.tick()
      }
    }
    if tickCount % 5 == 0 {
      // persist timers every 5 seconds
      persistTimers()
    }
    
    tickCount++
  }
  
  public func loadPersistedTimers() -> [Timer] {
    var timers = [Timer]()
    let defaults = NSUserDefaults(suiteName: AppGroupName)
    if let timersData = defaults?.dataForKey(TimersUserDefaultsKey) {
      if let unarchivedTimers = NSKeyedUnarchiver.unarchiveObjectWithData(timersData) as? [Timer] {
        timers = unarchivedTimers
      }
    }
    
    return timers
  }
  
  public func persistTimers() {
    let defaults = NSUserDefaults(suiteName: AppGroupName)
    let timersData = NSKeyedArchiver.archivedDataWithRootObject(timers)
    defaults?.setObject(timersData, forKey: TimersUserDefaultsKey)
  }
}