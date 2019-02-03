//
//  RNStepModule.m
//  pedometer
//
//  Created by Fitz on 2019/1/31.
//  Copyright © 2019年 Facebook. All rights reserved.
//


//
// Created by Fitz on 2019-01-29.
// Copyright (c) 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
@interface RCT_EXTERN_MODULE (StepCounter, RCTEventEmitter)
RCT_EXTERN_METHOD(start:(RCTResponseSenderBlock)callback);
@end

//libsystem_kernel.dylib`__abort_with_payload =>  info.plist


