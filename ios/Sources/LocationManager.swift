//
//  LocationManager.swift
//  App
//
//  Created by Fitz on 2019/2/1.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation
import CoreLocation


@objc(Location)
class LocationManager: RCTEventEmitter, CLLocationManagerDelegate {


    public var manager: CLLocationManager;
    var lastCoordinate: CLLocationCoordinate2D?;
    var totalDistance: Double = 0.0;

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }

    func dispatch(name: String, payload: Any) -> Void {
        self.sendEvent(withName: name, body: payload)
    }

    override func supportedEvents() -> [String]! {
        return ["authorizationStatusDidChange", "headingUpdated", "locationUpdated", "onWarning"]
    }

    override init() {
        self.manager = CLLocationManager()
        super.init();
        self.manager.delegate = self
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.dispatch(name: "onWarning", payload: ["onWarning"])
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!;
        let decoder = CLGeocoder.init();
        decoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            guard (placemarks != nil && placemarks!.count >= 1) else {
                return;
            }
            let location = placemarks?.first?.location;
            let coordinate = location!.coordinate;
            //位置的坐标在不停的改变

          var distance = 0.0;
          var shouldDispatch = false;
            if (self.lastCoordinate == nil) {
              shouldDispatch = true
            }else{
              shouldDispatch = compareCoordinate(current: coordinate, last: self.lastCoordinate!);
              distance = getDistance(coordinate, self.lastCoordinate!)
          }
            self.totalDistance = distance + self.totalDistance;
          
            self.lastCoordinate = coordinate;
            if (shouldDispatch == true) {
                self.dispatch(name: "locationUpdated", payload: [
                    "coordinate": [
                        "latitude": coordinate.latitude,
                        "longitude": coordinate.longitude,
                    ],
                    "distance": self.totalDistance
                ])
            }

        })


    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {


    }


    @objc func start() {
        self.manager.pausesLocationUpdatesAutomatically = true;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = 1;
        self.manager.activityType = CLActivityType.fitness
        self.manager.allowsBackgroundLocationUpdates = true;
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization();
        self.manager.startUpdatingLocation();
        self.manager.startUpdatingHeading();

    }


}






