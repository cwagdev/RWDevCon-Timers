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
  public var duration: Double
  public var elapsed: Double {
    get {
      if let startDate = self.startDate {
        return NSDate().timeIntervalSinceDate(startDate)
      } else {
        return 0
      }
    }
  }
  public private(set) var inProgress: Bool = false
  public var expired: Bool {
    return elapsed >= duration
  }
  
  public var tickBlock: (Timer -> Void)?
  private var startDate: NSDate?
  
  public init(duration: Double) {
    self.duration = duration
  }
  
  required public init(coder aDecoder: NSCoder) {
    self.uuid = aDecoder.decodeObjectForKey("uuid") as String
    self.startDate = aDecoder.decodeObjectForKey("startDate") as? NSDate
    self.duration = aDecoder.decodeDoubleForKey("duration")
    self.inProgress = aDecoder.decodeBoolForKey("inProgress")
  }
  
  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(uuid, forKey: "uuid")
    aCoder.encodeDouble(duration, forKey: "duration")
    aCoder.encodeBool(inProgress, forKey: "inProgress")
    
    if let startDate = startDate {
      aCoder.encodeObject(startDate, forKey: "startDate")
    }
  }
  
  public func stop() {
    startDate = nil
    inProgress = false
  }
  
  public func start() {
    inProgress = true
    startDate = NSDate()
  }
  
  public func tick(amount: Double = 1) {
    tickBlock?(self)
    if expired == true {
      stop()
      duration = 0
    }
  }
  
  public func remainingDurationInHoursAndMinutes() -> (hours: Int, minutes: Int) {
    let hours = Int(duration-elapsed / (60 * 60))
    let minutes = (Int(duration-elapsed) - (hours * 60 * 60)) / 60
    
    return (hours, minutes)
  }
}

public func == (lhs: Timer, rhs: Timer) -> Bool {
  return lhs.uuid == rhs.uuid
}