import React, { Component } from "react";
import { NativeModules, NativeEventEmitter } from "react-native";
const { StepCounter } = NativeModules;
const StepCounterEmitter = new NativeEventEmitter(StepCounter);

const supportedEvents = StepCounter.events;
export default class StepCounterModule {
  constructor(listener) {
    for (let event in supportedEvents) {
      StepCounterEmitter.addListener(event, data => listener(event, data));
    }
    StepCounter.start();
  }
  static supportedEvents = StepCounter.events;
}
