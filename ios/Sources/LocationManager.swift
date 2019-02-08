//
//  LocationManager.swift
//  App
//
//  Created by Fitz on 2019/2/1.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation
import CoreLocation

let COORDINATE_LAT_DELTA = 0.00001;
let COORDINATE_LNG_DELTA = 0.00001;
let COORDINATE_CHANGE_DELTA = pow(COORDINATE_LNG_DELTA, 2)
let EARTH_RADIUS = 6378.137;
let KM_DELTA = 1.609344;

func rad(_ input: Double) -> Double {
    let pie = Double.pi;
    return input * pie / 180.0
}

//https://blog.csdn.net/yi412/article/details/70182769
func getDistance(_ first: CLLocationCoordinate2D, _ second: CLLocationCoordinate2D?) -> Double {

    if (second == nil) {
        return 0.0;
    }

    let radLat1 = rad(first.latitude);
    let radLat2 = rad(second!.latitude);
    let radLng1 = rad(first.latitude);
    let radLng2 = rad(second!.latitude);

    let deltaLat = radLat1 - radLat1;
    let deltaLng = radLng1 - radLng2;

    let sinLngDelta = sin(deltaLng / 2);
    let sinLatDelta = sin(deltaLat / 2);
  
  let powOfLatDelta = pow(sinLngDelta,2)
  let coses = cos(radLat1) *  cos(radLat2);
  let   delta = powOfLatDelta + (sinLatDelta * coses)
  let square = sqrt(delta);
  let doulbeAndAsin = 2 * asin(square);
  let withEarthRadius =  doulbeAndAsin * EARTH_RADIUS
  let withRound = round(withEarthRadius * 10000) / 1000;
  
  let withKMDelta = withRound * KM_DELTA
  return withKMDelta

}


class LocationManager: NSObject, CLLocationManagerDelegate {
    public var manager: CLLocationManager;
    var currentCoordinate: CLLocationCoordinate2D?;
    var currentLocation:CLLocation?
    var totalDistance: Double = 0.0;
    var isActive = false;
    public var dispatch = noopDispatcher

    static func requiresMainQueueSetup() -> Bool {
        return true
    }

    override init() {

        self.manager = CLLocationManager();
        super.init();
        self.manager.delegate = self
        self.manager.pausesLocationUpdatesAutomatically = true;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = 1;
        self.manager.activityType = CLActivityType.fitness
        self.manager.allowsBackgroundLocationUpdates = true;
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization();
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
          
          guard (location!.horizontalAccuracy >= 0.0 ) else {
            return ;
          }
          
          
            var distance = 0.0
          
          if(location!.course > 0){
            distance = getDistance(coordinate, self.currentCoordinate)
          
          }
          
      
          
            let totalDistance = distance + self.totalDistance
            self.dispatch(
                    SportModule.events.locationUpdated,
                    [
                        "coordinate": [
                            "latitude": coordinate.latitude,
                            "longitude": coordinate.longitude,
                        ],
                        "distance": totalDistance,
                        "accuracy":[
                            "horizontal":location?.horizontalAccuracy,
                            "vertical":location?.verticalAccuracy,
                        ],
                        "altitude":location!.altitude,
                        "course":location!.course

                    ]
            )
          self.totalDistance = totalDistance;
          self.currentCoordinate = coordinate;
          self.currentLocation = location;
          
        })
      
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {

        self.dispatch(SportModule.events.locationHeadingUpdated, ["heading": newHeading.trueHeading])

//        print("newHeading \(newHeading)")

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






