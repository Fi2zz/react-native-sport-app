import React, { Component } from "react";
import { NativeModules, NativeEventEmitter } from "react-native";
const NativeSportModule = NativeModules.SportModule;
class SportModule {
  constructor() {
    this.eventEmitter = new NativeEventEmitter(NativeSportModule);
  }
  addListener(event, handler) {
    this.eventEmitter.addListener(event, handler);
  }
  start = next => {
    if (!next) {
      NativeSportModule.start(false);
    } else {
      NativeSportModule.start(true);
      next();
    }
  };
  stop = next => {
    NativeSportModule.stop();
    next();
  };
}
export const Sport = new SportModule();
