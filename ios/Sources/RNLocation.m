//
//  RNLocation.m
//  StepCounterApp
//
//  Created by Fitz on 2019/2/2.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE (Location, RCTEventEmitter)

RCT_EXTERN_METHOD(start);

@end
