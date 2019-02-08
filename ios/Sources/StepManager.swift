//
// Created by Fitz on 2019-01-29.
// Copyright (c) 2019 Facebook. All rights reserved.
//

import Foundation
import CoreMotion;

class StepManager {

    let rangeDelta = -0.12;
    // 加速度传感器采集的原始数组
    var raw: [StepModel] = [];
    var rawAcceleration: [CMAcceleration] = []
    var dateOfRecording: Date = Date();
    var stepsOfRecording: Int = 0;
    var currentSteps: Int = 0;
    var isWalkingOrRunning = false;
  //motion manager
    let motion = CMMotionManager();
    //health manager
    let health = HealthManager();
    let activity = CMMotionActivityManager();
    public var dispatch = noopDispatcher;

    static func requiresMainQueueSetup() -> Bool {
        return false
    }

    func stop() {
        self.motion.stopAccelerometerUpdates();
        self.activity.stopActivityUpdates();
        self.saveStepsToHealthKit(steps: Double(self.currentSteps), start: self.dateOfRecording, end: Date())
    }

    func queryStepsOnLaunch() {
        //启动时查询步数
        let stepsQueryType = self.health.QueryTypes.steps;
        self.health.query(type: stepsQueryType, handler: { (steps) -> Void in
            self.dispatch(SportModule.events.start, ["steps": Int(steps)])
        })
    }

    func activityUpdates() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.activity.startActivityUpdates(to: OperationQueue.main) {
                (data: CMMotionActivity!) -> Void in
                self.isWalkingOrRunning = data.running || data.walking;
            }
        }
    }

    func start() {
        self.health.authorization();
        if (!self.motion.isAccelerometerAvailable) {
            return;
        }
        self.activityUpdates()
        self.motion.accelerometerUpdateInterval = StepModel.accelerometerUpdateInterval;
        self.startAccelerometer();
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
          // 每采集10条，大约1.2秒的数据时，进行分析
            if (self.raw.count == 10) {
                self.calculateAndDispatch(self.raw);
                self.raw.removeAll(keepingCapacity: true);
            }
        })
    }


    func calculateAndDispatch(_ cache: [StepModel]) {

        // 踩点数组
        var sample: [StepModel] = []
        //遍历步数缓存数组
        for (index, current) in cache.enumerated() {
            //如果数组个数大于3,继续,否则跳出循环,用连续的三个点,要判断其振幅是否一样,如果一样,然并卵
            if (index >= 1 && index < cache.count - 2) {
                let prev = cache[index - 1];
                let next = cache[index + 1];
                let con = current.range < self.rangeDelta && current.range < prev.range && current.range < next.range
                if (con) {
                    sample.append(current)
                }
            }
        }


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
                  
                    self.dispatch(SportModule.events.walk, ["steps": 1]);
                    let every10Minutes = Int(now.timeIntervalSince1970) - Int(self.dateOfRecording.timeIntervalSince1970) > StepModel.SAVE_INTERVAL
                    //每5分钟记录一次数据
                    if (every10Minutes && self.currentSteps > 0) {
                        self.saveStepsToHealthKit(steps: Double(self.currentSteps), start: self.dateOfRecording, end: now)
                    }
                }
            }


        }


    }


    func tendToZero(_ value: Double) -> Double {
        if (value < 0) {
            return ceil(value);
        } else {
            return floor(value);
        }

    }

 
  

}
