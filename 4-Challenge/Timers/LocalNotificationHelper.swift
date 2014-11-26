//
//  LocalNotificationHelper.swift
//  Timers
//
//  Created by Chris Wagner on 11/25/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import Foundation
import TimerKit

class LocalNotificationHelper {
  
  class func scheduleNotification(forTimer timer: Timer) -> UILocalNotification {
    let notification = UILocalNotification()
    notification.fireDate = NSDate(timeIntervalSinceNow: timer.duration - timer.elapsed)
    notification.alertBody = ""
    notification.soundName = UILocalNotificationDefaultSoundName
    notification.applicationIconBadgeNumber += 1
    notification.userInfo = ["timerUUID": timer.uuid]
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    return notification
  }
  
  class func cancelNotification(forTimer timer: Timer) {
    if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications as? [UILocalNotification] {
      for notification in notifications {
        if let uuid = notification.userInfo?["timerUUID"] as? String {
          if timer.uuid == uuid {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
          }
        }
      }
    }
  }
}