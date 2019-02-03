//
// Created by Fitz on 2019-02-03.
// Copyright (c) 2019 Facebook. All rights reserved.
//

import Foundation

import CoreLocation

let EARTH_RADIUS = 6378.137;

let KM_DELTA = 1.609344;

func getRadius(_ input: Double) -> Double {
    let pie = Double.pi;
    return input * pie / 180.0
}

//
//double radLat2 = rad(lat2);
//double a = radLat1 - radLat2;
//double b = rad(lng1) - rad(lng2);
//double s = 2 * Math.Asin(
//Math.Sqrt(
//  Math.Pow(
//        Math.Sin(a/2),2)
//      + Math.Cos(radLat1)
//      * Math.Cos(radLat2)
//      * Math.Pow(
//          *Math.Sin(b/2),2)
//)
//  );
//s = s * EARTH_RADIUS;
//s = Math.Round(s * 10000) / 10000;
//return s;

//https://blog.csdn.net/yi412/article/details/70182769

func getDistance(_ first: CLLocationCoordinate2D, _ second: CLLocationCoordinate2D) -> Double {


    let radLat1 = getRadius(first.latitude);
    let radLat2 = getRadius(second.latitude);
    let radLng1 = getRadius(first.latitude);
    let radLng2 = getRadius(second.latitude);


    let deltaLat = radLat1 - radLat1;
    let deltaLng = radLng1 - radLng2;


    let sinLng = sin(deltaLng / 2);
    let sinLat = sin(deltaLat / 2);


    let cos1 = cos(radLat1);
    let cos2 = cos(radLat2);

    let cosSqrt = cos2 * cos1

    let powOfLng = pow(sinLng, 2);


    let v1 = (powOfLng * cosSqrt) + sinLat;

    let powOfV1 = pow(v1, 1);


    let square = sqrt(powOfV1)
    let t = asin(square) * 2 * EARTH_RADIUS;

    let miles = t * 1000
    let d = round(miles) / 1000 * KM_DELTA;
    return d


}
