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

func getRadius(_ input: Double) -> Double {
    let pie = Double.pi;
    return input * pie / 180.0
}

//https://blog.csdn.net/yi412/article/details/70182769
func getDistance(_ first: CLLocationCoordinate2D, _ second: CLLocationCoordinate2D?) -> Double {

    if (second == nil) {
        return 0.0;
    }

    let radLat1 = getRadius(first.latitude);
    let radLat2 = getRadius(second!.latitude);
    let radLng1 = getRadius(first.latitude);
    let radLng2 = getRadius(second!.latitude);
    let deltaLat = radLat1 - radLat1;
    let deltaLng = radLng1 - radLng2;
    let sinLng = sin(deltaLng / 2);
    let sinLat = sin(deltaLat / 2);

    let cos1 = cos(radLat1);
    let cos2 = cos(radLat2);
    let result = (pow(sinLng, 2) * cos2 * cos1) + sinLat;
    let miles = asin(sqrt(pow(result, 2))) * 2 * EARTH_RADIUS * 1000;
    return round(miles) / 1000 * KM_DELTA


}


func getDeltaBetweenCoordinates(_ v1: CLLocationCoordinate2D, _ v2: CLLocationCoordinate2D?) -> Dictionary<String, Double> {
    if (v2 == nil) {
        return ["latitude": 0.0, "longitude": 0.0]
    }
    let latDelta = pow(v1.latitude - v2!.latitude, 2);
    let lngDelta = pow(v1.longitude - v2!.longitude, 2);
    return ["latitude": latDelta, "longitude": lngDelta]
}

func CheckIfCanDispatchEvent(_ v1: CLLocationCoordinate2D, _ v2: CLLocationCoordinate2D?) -> Bool {
    if (v2 == nil) {
        return true;
    }
    let deltas = getDeltaBetweenCoordinates(v1, v2!);
    let longitude = Double(deltas["longitude"]!)
    let latitude = Double(deltas["latitude"]!)
    return latitude > COORDINATE_CHANGE_DELTA && longitude > COORDINATE_CHANGE_DELTA;
}


class LocationManager: NSObject, CLLocationManagerDelegate {
    public var manager: CLLocationManager;
    var lastCoordinate: CLLocationCoordinate2D?;
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
        self.dispatch("onWarning", ["onWarning"])
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
            let currCoordinate = location!.coordinate;
            let shouldDispatch = CheckIfCanDispatchEvent(currCoordinate, self.lastCoordinate)
            let comparation = getDeltaBetweenCoordinates(currCoordinate, self.lastCoordinate)


            //payload
            let coordinate = [
                "latitude": currCoordinate.latitude,
                "longitude": currCoordinate.longitude,
            ]

            let comp = [
                "lat": comparation["latitude"],
                "lng": comparation["longitude"]
            ]


            self.dispatch(
                    "comparation",
                    [
                        "shouldDispatch": shouldDispatch,
                        "coordinate": coordinate,
                        "comparation": comp,
                    ])
            if (shouldDispatch == true) {

                let distance = getDistance(currCoordinate, self.lastCoordinate)
                self.totalDistance = distance + self.totalDistance;
                self.dispatch(
                        "locationUpdated",
                        [
                            "coordinate": coordinate,
                            "distance": distance,
                        ])


            }

            self.lastCoordinate = currCoordinate;
//            self.lastLocation = location;
        })

    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {


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






