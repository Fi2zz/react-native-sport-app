import React, { Component } from "react";
import { NativeModules, NativeEventEmitter } from "react-native";
const NativeSportModule = NativeModules.SportModule;
// alert(Object.keys(NativeSportModule))
export class SportModule {
  constructor() {
    this.eventEmitter = new NativeEventEmitter(NativeSportModule);
  }
  addListener(event, handler) {
    this.eventEmitter.addListener(event, handler);
  }

  start = next => {
    if (!next) {
      NativeSportModule.start(true);
    } else {
      NativeSportModule.start(false);
      next();
    }
  };
  stop = next => {
    NativeSportModule.stop();
    next();
  };
}

export const Sport = new SportModule();
