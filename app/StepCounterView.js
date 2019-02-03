import React from "react";
import { View, Text, StyleSheet } from "react-native";
import SafeAreaView from "react-native-safe-area-view";

const styles = StyleSheet.create({
  text: {
    fontSize: 32,
    color: "#222",
    textAlign: "center",
    fontFamily: "Bebas Neue"
  },

  container: {
    paddingHorizontal: 16,
    backgroundColor: "#fff",
    borderRadius: 20,
    shadowColor: "rgba(0,0,0,.3)",
    shadowOffset: {
      width: 5,
      height: 5
    },
    shadowOpacity: 0.5,
    shadowRadius: 20
  },
  row: {
    alignItems: "center",
    justifyContent: "space-between",
    flexDirection: "row",
    paddingVertical: 16,
    flex: 1
  },

  labelText: {
    marginBottom: 12
  },
  rowItem: {
    alignItems: "flex-start",
    justifyContent: "flex-start"
  }
});

export default class StepCounterView extends React.Component {
  render() {
    const { distance, steps, time } = this.props;
    return (
      <SafeAreaView
        forceInset={{
          bottom: "always",
          top: "never",
          left: "always",
          right: "always"
        }}
      >
        <View style={styles.container}>
          <View style={styles.row}>
            <View style={styles.rowItem}>
              <Text style={styles.labelText}>步数</Text>
              <Text style={styles.text}>{steps}</Text>
            </View>
            <View style={styles.rowItem}>
              <Text style={styles.labelText}>时间</Text>
              <Text style={styles.text}>{time}</Text>
            </View>
            <View style={styles.rowItem}>
              <Text style={styles.labelText}>距离(km)</Text>
              <Text style={styles.text}>{distance}</Text>
            </View>
          </View>
        </View>
      </SafeAreaView>
    );
  }
}
