import React from "react";
import { View, Text } from "react-native";
import SafeAreaView from "react-native-safe-area-view";
import { DisplayStyle as styles } from "./styles";

export default function DisplayView(props) {
  const { distance, steps, time } = props;
  const forceInset = {
    bottom: "always",
    top: "never",
    left: "always",
    right: "always"
  };
  return (
    <View style={styles.container}>
      <SafeAreaView forceInset={forceInset}>
        {props.children}
        <View style={styles.rowContainer}>
          <View style={styles.row}>
            <View style={styles.firstItem}>
              <Text style={styles.labelText}>步数</Text>
              <Text style={styles.text}>{steps}</Text>
            </View>
            <View style={styles.centerItem}>
              <Text style={styles.labelText}>时间</Text>
              <Text style={styles.text}>{time}</Text>
            </View>
            <View style={styles.lastItem}>
              <Text style={styles.labelText}>距离(km)</Text>
              <Text style={styles.text}>{distance}</Text>
            </View>
          </View>
        </View>
      </SafeAreaView>
    </View>
  );
}
