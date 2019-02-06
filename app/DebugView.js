import React from "react";
import { Text, View } from "react-native";
import { AppStyle as styles } from "./styles";
import SafeAreaView from "react-native-safe-area-view";

export function DebugView(props) {
  const { debug } = props;
  const { comparation, coordinate, speed, polylines, shouldDispatch } = debug;
  return (
    <View style={styles.counterViewChildrenContainer}>
      <SafeAreaView forceInset={{ top: "always" }}>
        <Text style={styles.debugLabel}>comparation</Text>
        <Text style={styles.debugLabel}>
          lat:
          {comparation.lat} / lng:
          {comparation.lng}
        </Text>

        <Text style={styles.debugLabel}>coordinate</Text>
        <Text style={styles.debugLabel}>
          lat:
          {coordinate.latitude} / lng:
          {coordinate.longitude}
        </Text>
        <Text style={styles.debugLabel}>
          location changed: {shouldDispatch.toString()} / speed:
          {speed} / polylines:
          {polylines.length}
        </Text>
      </SafeAreaView>
    </View>
  );
}
