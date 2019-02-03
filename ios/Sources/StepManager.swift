//
// Created by Fitz on 2019-01-29.
// Copyright (c) 2019 Facebook. All rights reserved.
//

import Foundation
import CoreMotion;

import CoreData;

import HealthKit;


@objc(StepCounter)
class StepCounter: RCTEventEmitter {
    // 加速度传感器采集的原始数组
    var raw: [StepModel] = [];
    //
    var dateOfRecording: Date = Date();
    var stepsOfRecording: Int = 0;
    var currentSteps: Int = 0;

    override func supportedEvents() -> [String]! {
        return EventsOfSupported
    }

    override static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc override func constantsToExport() -> [AnyHashable: Any]! {
        return ["events": stringListToStringMap(list: EventsOfSupported)]
    }

    @objc func events() -> [String]! {
        return EventsOfSupported;
    }

    func dispatch(name: String, payload: Any) -> Void {
        self.sendEvent(withName: name, body: payload)
    }

    //motion manager
    let motion = CMMotionManager();
    //health manager
    let health = HealthManager();

    var isWalkingOrRunning = false;


    @objc func start(_ callback: @escaping RCTResponseSenderBlock) {


        if (!self.motion.isAccelerometerAvailable) {
            return;
        }
        self.motion.accelerometerUpdateInterval = StepModel.accelerometerUpdateInterval;
        self.health.authorization();
        //启动时查询步数
        let stepsQueryType = self.health.QueryTypes.steps;
        self.health.query(type: stepsQueryType, handler: { (steps) -> Void in
            self.dispatch(name: "start", payload: ["steps": Int(steps)])
        })
        getActivityType({
            (type: String) -> Void in
            self.isWalkingOrRunning = type == activityTypes.Running || type == activityTypes.Walking;
            self.dispatch(name: "activity", payload: ["activity": type])
        })
        self.startAccelerometer();
    }

    func saveStepsToApp() {
    }

    func saveStepsToHealthKit(steps: Double, start: Date, end: Date) {
        self.health.saveSteps(
                steps: steps,
                startTime: start,
                endTime: end
        );
        self.currentSteps = 0;
        self.stepsOfRecording = 0;
        self.dateOfRecording = end;
    }

    func startAccelerometer() {
        let queue = OperationQueue();
        self.motion.startAccelerometerUpdates(to: queue, withHandler: {
            (data, error) in
            guard(self.motion.isAccelerometerActive != false) else {
                return;
            }

            let data = data!
            let x = data.acceleration.x;
            let y = data.acceleration.y;
            let z = data.acceleration.z;
            //设定振幅，用于计算是不是走了一步
            let range: Double = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)) - 1
            let count = StepModel(range: range, date: Date())
            // 加速度传感器采集的原始数组
            self.raw.append(count);
            // 每采集30条，大约3秒的数据时，进行分析
            if (self.raw.count == 30) {
                self.dataFilter(cache: self.raw);
                self.raw.removeAll(keepingCapacity: true);
            }
        })
    }

    func caculateAndDispatch(sample: [StepModel]) {

        // 踩点过滤

        for current in sample {


            let now = Date();
            let interval = current.date!.timeIntervalSince(self.dateOfRecording) * 1000;
            let steppingInterval = Int(interval);
            let min: Int = 259;

            if (steppingInterval >= min && self.motion.isAccelerometerActive) {

                if (steppingInterval >= StepModel.ACCELEROMETER_START_TIME * 1000) {// 计步器开始计步时间（秒)
                    self.stepsOfRecording = 0;
                }

                if (self.stepsOfRecording < StepModel.ACCELEROMETER_START_STEP) {//计步器开始计步步数 (步)
                    self.stepsOfRecording += 1;
                    break;
                } else if (self.stepsOfRecording == StepModel.ACCELEROMETER_START_STEP) {
                    self.stepsOfRecording += 1;
                    // 计步器开始步数
                    // 运动步数（总计）
                    self.currentSteps = self.currentSteps + self.stepsOfRecording;
                } else {
                    self.currentSteps += 1;
                }


                if (self.isWalkingOrRunning) {
                    self.dispatch(name: "walk", payload: ["steps": 1]);

                    //每10步记录一次数据
                    if (Int(now.timeIntervalSince1970) - Int(self.dateOfRecording.timeIntervalSince1970) >= 1) {
                        self.saveStepsToHealthKit(steps: Double(self.currentSteps), start: self.dateOfRecording, end: now)
                    }
                }

            }


        }


    }

    func dataFilter(cache: [StepModel]) {
        // 踩点数组
        var sample: [StepModel] = []
        //遍历步数缓存数组
        for (index, current) in cache.enumerated() {
            //如果数组个数大于3,继续,否则跳出循环,用连续的三个点,要判断其振幅是否一样,如果一样,然并卵
            if (index >= 1 && index < cache.count - 2) {
                let prev = cache[index - 1];
                let next = cache[index + 1];
                let con = current.range < -0.15 && current.range < prev.range && current.range < next.range
                if (con) {
                    sample.append(current)
                }
            }
        }
        self.caculateAndDispatch(sample: sample)

    }


}
