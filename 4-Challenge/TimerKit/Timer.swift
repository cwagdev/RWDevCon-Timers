//
//  Timer.swift
//  Timers
//
//  Created by Chris Wagner on 11/26/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import Foundation

public class Timer: NSObject, NSCoding, Equatable {
  
  public let uuid = NSUUID().UUIDString
  public var duration: Double {
    willSet {
      elapsed = 0
    }
  }
  public private(set) var elapsed: Double = 0
  public private(set) var inProgress: Bool = false
  public var expired: Bool {
    return elapsed >= duration
  }
  
  public var tickBlock: (Timer -> Void)?
  private var notification: UILocalNotification?
  
  public init(duration: Double) {
    self.duration = duration
  }
  
  required public init(coder aDecoder: NSCoder) {
    self.uuid = aDecoder.decodeObjectForKey("uuid") as String
    self.duration = aDecoder.decodeDoubleForKey("duration")
  }
  
  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(uuid, forKey: "uuid")
    aCoder.encodeDouble(duration, forKey: "duration")
  }
  
  public func stop() {
    inProgress = false
    if let notification = notification {
      UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
  }
  
  public func start() {
    inProgress = true
    if expired == false {
      notification = UILocalNotification()
      if let notification = notification {
        notification.fireDate = NSDate(timeIntervalSinceNow: duration - elapsed)
        notification.alertBody = ""
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber += 1
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
      }
    }
  }
  
  public func tick(amount: Double = 1) {
    elapsed += amount
    tickBlock?(self)
    if expired == true {
      stop()
      elapsed = 0
      duration = 0
    }
  }
  
  public func durationInHoursAndMinutes() -> (hours: Int, minutes: Int) {
    let hours = Int(duration-elapsed / (60 * 60))
    let minutes = (Int(duration-elapsed) - (hours * 60 * 60)) / 60
    
    return (hours, minutes)
  }
}

public func == (lhs: Timer, rhs: Timer) -> Bool {
  return lhs.uuid == rhs.uuid
}