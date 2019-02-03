import React from "react";
import { NativeModules, NativeEventEmitter } from "react-native";

const { Location } = NativeModules;

const LocationEmitter = new NativeEventEmitter(Location);
export default class LocationModule {
  constructor(handler) {
    LocationEmitter.addListener("locationUpdated", handler);
    Location.start();
  }
}
