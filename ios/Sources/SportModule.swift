//
//  SportModule.swift
//  Sport
//
//  Created by Fitz on 2019/2/6.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation
class SportModuleEvents {
    let start = "start"
    let walk = "walk"
    let activity = "activity"
    let locationAuthorizationStatusDidChange = "locationAuthorizationStatusDidChange"
    let locationHeadingUpdated = "locationHeadingUpdated"
    let locationUpdated = "locationUpdated"
    let locationWarning = "locationWarning"
}

@objc(SportModule)
class SportModule: RCTEventEmitter {
   
    static let events = SportModuleEvents();
    public static func noopDispatcher(name: String, payload: Any?) -> Void {
    }
    override func supportedEvents() -> [String]! {
        return [
            SportModule.events.activity,
            SportModule.events.walk,
            SportModule.events.start,
            SportModule.events.locationAuthorizationStatusDidChange,
            SportModule.events.locationHeadingUpdated,
            SportModule.events.locationUpdated,
            SportModule.events.locationWarning,
        ]
    }
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    let location = LocationManager()
    let step = StepManager();
    override init() {
        super.init();
        func dispatch(name: String, payload: Any?) {
            self.sendEvent(withName: name, body: payload);
        }
        self.location.dispatch = dispatch
        self.step.dispatch = dispatch
    }

    @objc func start(_ shouldStartStepManager: Bool) -> Void {
        self.stop(true);
        if (shouldStartStepManager == true) {
            self.step.start();
        }
        self.location.start();
    }

    @objc func stop(_ shouldStopUpdateLocation: Bool = true) -> Void {
        if (shouldStopUpdateLocation == true) {
            self.location.stop();
        }
        self.step.stop();
    }
}




