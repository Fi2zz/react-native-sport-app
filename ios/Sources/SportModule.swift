//
//  MainApp.swift
//  Sport
//
//  Created by Fitz on 2019/2/6.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation
import CoreLocation;


@objc(SportModule)
class SportModule: RCTEventEmitter {
    override func supportedEvents() -> [String]! {
        return [

            "start",
            "walk",
            "activity",
            "speed",
            "locationAuthorizationStatusDidChange",
            "locationHeadingUpdated",
            "locationUpdated",
            "locationWarning"
        ]
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }


    var location = LocationManager()
    var step = StepManager();
  var isActive = false;
    override init() {

        super.init();

        func dispatch(name: String, payload: Any?) {
            self.sendEvent(withName: name, body: payload);
        }

        self.location.dispatch = dispatch
        self.step.dispatch = dispatch
    }

    @objc func start(_ startLocationManager: Bool) {
      
      
      if(self.isActive){
        self.stop();
      }
      
      
      self.isActive = true;

        if (startLocationManager != false) {
            self.step.start();
        }
        self.location.stop();
        self.location.start();


    }

    @objc func stop() {
      self.isActive = false;
        self.location.stop();
        self.step.stop();
    }


}

