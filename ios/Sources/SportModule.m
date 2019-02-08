//
//  RNSportModule.m
//  Sport
//
//  Created by Fitz on 2019/2/6.
//  Copyright © 2019年 Facebook. All rights reserved.
//


#import <Foundation/Foundation.h>


#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE (SportModule, RCTEventEmitter)

RCT_EXTERN_METHOD(start:
    (BOOL) shouldStartStepManager);

RCT_EXTERN_METHOD(stop:
    (BOOL) shouldStopUpdateLocation);
@end



