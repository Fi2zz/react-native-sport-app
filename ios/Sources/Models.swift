//
//  Models.swift
//  StepCounterApp
//
//  Created by Fitz on 2019/2/3.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation


class StepModel: NSObject {

    static let ACCELEROMETER_START_TIME: Int = 2;
    static let ACCELEROMETER_START_STEP: Int = 0;
    static let DB_STEP_INTERVAL: Int = 1;
    static let accelerometerUpdateInterval = 1.0 / 30.0;
    //写入health data的时间间隔
    static let SAVE_INTERVAL: Int = 60 * 10 * 10
    var date: Date?;
    var range: Double = 0.0;

    override init() {
        super.init();
    }

    convenience init(range: Double, date: Date) {
        self.init();
        self.range = range;
        self.date = date;
    }
}
