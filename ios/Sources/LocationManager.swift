//
//  LocationManager.swift
//  App
//
//  Created by Fitz on 2019/2/1.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    public var manager: CLLocationManager;
    var currentCoordinate: CLLocationCoordinate2D?;
    var currentLocation:CLLocation?
    var totalDistance: Double = 0.0;
    var isActive = false;
    public var dispatch = noopDispatcher
    public var shouldSendDistance = false;
    static func requiresMainQueueSetup() -> Bool {
        return true
    }

    override init() {
        self.manager = CLLocationManager();
        super.init();
        self.manager.delegate = self
        self.manager.pausesLocationUpdatesAutomatically = true;
        self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.manager.distanceFilter = kCLDistanceFilterNone;
        self.manager.activityType = CLActivityType.fitness
        self.manager.requestWhenInUseAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.dispatch(SportModule.events.locationWarning, ["onWarning"])
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else {
            return;
        }
        let location = locations.last!;
        let decoder = CLGeocoder.init();
        decoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            guard (placemarks != nil && placemarks!.count >= 1) else {
                return;
            }
            let location = placemarks?.first?.location;
            let coordinate = location!.coordinate;
             //水平方向精度小于0表示数据不可信
             guard (location!.horizontalAccuracy >= 0.0 ) else {
               return ;
             }
             var shouldDispatch = false;
             //gps、wifi、基站信号，数值越大信号越差，小于0 为没有信号
             if(location!.horizontalAccuracy > 0 && location!.horizontalAccuracy <= 120){
                    shouldDispatch = true;
             }  
             if(self.currentLocation == nil){
                 shouldDispatch = true;
             }
              if(shouldDispatch){
                var distance = 0.0;
                if(self.shouldSendDistance){
                  distance = location!.distance(from: self.currentLocation!) / 1000 + self.totalDistance
                }
                self.dispatch(
                            SportModule.events.locationUpdated,
                            [
                                "coordinate": [
                                    "latitude": coordinate.latitude,
                                    "longitude": coordinate.longitude,
                                ],
                                "distance": distance,
                                "accuracy":[
                                    "horizontal":location?.horizontalAccuracy,
                                    "vertical":location?.verticalAccuracy,
                                ],
                                "altitude":location!.altitude,
                                "course":location!.course

                            ]
                    )
          
                self.totalDistance = distance;
          }
          self.currentCoordinate = coordinate;
          self.currentLocation = location;
        })
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.dispatch(SportModule.events.locationHeadingUpdated, ["heading": newHeading.trueHeading])
    }
    func stop() {
        self.isActive = false;
        self.manager.stopUpdatingLocation();
        self.manager.stopUpdatingHeading()
    }
    func start() {
        if (self.isActive) {
            self.stop();
        }
        self.isActive = true;
        self.manager.startUpdatingLocation();
        self.manager.startUpdatingHeading();
    }

    
    
}









