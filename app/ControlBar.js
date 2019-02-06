import React from "react";
import { View, TouchableOpacity, Text, StyleSheet, Image } from "react-native";
const source = {
  start: require("./assets/icon-start.png"),
  pause: require("./assets/icon-pause.png")
};
const styles = StyleSheet.create({
  container: {
    justifyContent: "flex-end",
    alignItems: "flex-end",
    height: 48,
    marginBottom: 12
  },
  iconImage: {
    width: 24,
    height: 24
  },
  iconContainer: {
    width: 44,
    height: 44,
    backgroundColor: "#05a571",
    borderRadius: 22,
    alignItems: "center",
    justifyContent: "center"
  }
});

export function ControlBar(props) {
  const { paused, onChange } = props;
  const icon = paused ? source.start : source.pause;
  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={styles.iconContainer}
        onPress={() => onChange(paused)}
      >
        <Image source={icon} style={styles.iconImage} />
      </TouchableOpacity>
    </View>
  );
}
