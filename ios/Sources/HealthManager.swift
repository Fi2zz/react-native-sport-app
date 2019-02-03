//
//  HealthManager.swift
//  pedometer
//
//  Created by Fitz on 2019/1/29.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation

import HealthKit;

let store = HKHealthStore();

//let healthDataToWrite =

let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!;
let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!;


let healthDataToWrite = Set(arrayLiteral: stepCountType);
let healthDataToRead = Set([stepCountType, distanceType]);

func noop(_ success: Bool, _ error: Error?) -> Void {
}

class HealthQueryTypes: NSObject {
    let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let distance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
}


public class HealthManager: NSObject {

    let QueryTypes = HealthQueryTypes()
    let healthKitStore: HKHealthStore = HKHealthStore()

    var authorized: Bool = false;

    public func authorization() {


        store.requestAuthorization(toShare: healthDataToWrite, read: healthDataToRead, completion: {
            (success, error) in
            if (error == nil) {
                self.authorized = true;
            }
        })
    }

    public func saveSteps(steps: Double, startTime: Date, endTime: Date) {


        guard self.authorized else {
            self.authorization();
            return;
        }
//        let endTime = Date();
        let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: steps);
        let sample = HKQuantitySample(type: stepCountType, quantity: quantity, start: startTime, end: endTime)
        //保存步数到健康应用
        store.save(sample, withCompletion: noop)
    }

    func createQueryPredicate() -> NSPredicate {

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        return predicate

    }


    public func query(type: HKQuantityType, handler: @escaping (Double) -> Void, predicate: NSPredicate? = nil) {

        let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate != nil ? predicate : self.createQueryPredicate(),
                options: .cumulativeSum) { _, result, error in

            guard let result = result, let sum = result.sumQuantity()
                    else {
                handler(0.0);
                return
            }
            let finalResult = sum.doubleValue(for: HKUnit.count())
            handler(finalResult);
        }
        store.execute(query)

    }

    public func queryDistance(handler: @escaping (Double) -> Void) {
        let now = Date();
        let prevHour = Calendar.current.date(byAdding: .minute, value: -10, to: now)
        let predicate = HKQuery.predicateForSamples(withStart: prevHour, end: now, options: .strictStartDate)
        self.query(type: self.QueryTypes.distance, handler: handler, predicate: predicate)
    }


}
