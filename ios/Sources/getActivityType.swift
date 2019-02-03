//
//  ActivityTypeManager.swift
//  pedometer
//
//  Created by Fitz on 2019/2/1.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation

import CoreMotion

let activityManager = CMMotionActivityManager();


public class activityTypes {
    static let Sitting = "Sitting"
    static let Walking = "Walking "
    static let Running = "Running "
    static let Automotive = "Automotive"
    static let Unknown = "Unknown"
    static let Cycling = "Cycling"
    static let Unavailable = "Unavailable"
}


public func getActivityType(_ callback: @escaping (String) -> Void) {

    if CMMotionActivityManager.isActivityAvailable() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            (data: CMMotionActivity!) -> Void in
            var activityType = activityTypes.Unknown
            if data.stationary == true {
                activityType = activityTypes.Sitting
            } else if data.walking == true {
                activityType = activityTypes.Walking
            } else if data.running == true {
                activityType = activityTypes.Running
            } else if data.automotive == true {
                activityType = activityTypes.Automotive
            } else if data.unknown == true {
                activityType = activityTypes.Unknown
            } else if data.cycling == true {
                activityType = activityTypes.Cycling
            }
            callback(activityType);
        }
    }
    callback(activityTypes.Unavailable);
}
  

