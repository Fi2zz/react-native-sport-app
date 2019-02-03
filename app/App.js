import React, { Component } from "react";
import { StyleSheet, View, Dimensions } from "react-native";

import StepCounterView from "./StepCounterView";
import LocationModule from "./LocationModule";
import Map from "./AppMap";
import StepCounterModule from "./StepCounterModule";
import { displayDateWithFormat } from "./utils";

const styles = StyleSheet.create({
  container: {
    flex: 1,
    width: screenWidth,
    height: screenHeight,
    backgroundColor: "#F5FCFF"
  },
  counterView: {
    position: "absolute",
    left: 0,
    right: 0,
    zIndex: 20,
    bottom: 0,
    paddingHorizontal: 20
  }
});

export default class App extends Component {
  state = {
    steps: 0,
    latitude: null,
    longitude: null,
    region: {
      latitude: null,
      longitude: null
    },
    polylines: [],
    distance: 0.0,
    time: displayDateWithFormat(new Date()),
    activityType: "Unavailable"
  };
  componentWillUnmount() {
    this.timer = null;
  }
  componentDidMount() {
    new StepCounterModule((event, data) => {
      switch (event) {
        // case StepCounterModule.supportedEvents.start:
        case StepCounterModule.supportedEvents.walk:
          this.setState({
            steps: data.steps + this.state.steps
          });
          break;
        case StepCounterModule.supportedEvents.activity:
          this.setState({
            activityType: data.activity
          });
          break;
      }
    });
    this.timer = setInterval(() => {
      this.setState({ time: displayDateWithFormat(new Date()) });
    }, 1000);
    new LocationModule(data => {
      const { coordinate, distance } = data;
      const { polylines } = this.state;

      this.setState({
        polylines: [...polylines, coordinate],
        region: coordinate,
        distance
      });
    });
  }

  render() {
    const { time, steps, distance, region, polylines } = this.state;
    return (
      <View style={styles.container}>
        <View style={styles.counterView}>
          <StepCounterView
            time={time}
            steps={steps}
            distance={distance.toFixed(2)}
          />
        </View>
        <Map region={region} polylines={polylines} />
      </View>
    );
  }
}
