import React, { Component } from "react";
import { View, Text } from "react-native";
import DisplayView from "./DisplayView";
import MapView from "./MapView";
import { ControlBar } from "./ControlBar";
import { Sport } from "./NativeModules";
import { Timer } from "./Timer";
import { AppStyle as styles } from "./styles";
import { DELTA } from "./utils";
import { DebugView } from "./DebugView";

export default class App extends Component {
  state = {
    steps: 0,
    region: {
      latitude: null,
      longitude: null,
      ...DELTA
    },
    polylines: [],
    distance: 0.0,
    time: "00:00:00",
    pause: true,
    speed: 0.0,
    debug: {
      shouldDispatch: true,
      comparation: {
        lat: null,
        lng: null
      },
      coordinate: {}
    }
  };

  componentDidMount() {
    this.create();
  }
  create() {
    try {
      Sport.addListener("walk", data => {
        this.setState({
          steps: data.steps + this.state.steps,
          speed: data.speed
        });
      });
      Sport.addListener(
        "comparation",
        ({ shouldDispatch, coordinate, comparation }) => {
          this.setState({
            debug: {
              shouldDispatch,
              coordinate,
              comparation
            }
          });
        }
      );
      Sport.addListener("locationUpdated", data => {
        const { coordinate, distance } = data;
        const { polylines, region } = this.state;
        polylines.push(coordinate);
        this.setState({
          polylines,
          distance,
          region: { region, ...coordinate }
        });
      });
      Sport.start();
    } catch (e) {}
  }

  onChange(isActive) {
    let shouldPaused = !isActive;
    if (shouldPaused) {
      Sport.stop(() => this.setState({ pause: shouldPaused }));
      Timer.pause();
    } else {
      Sport.start(() => {
        Timer.start(display => {
          this.setState({ time: display, pause: shouldPaused });
        });
      });
    }
  }

  render() {
    const {
      time,
      steps,
      distance,
      region,
      polylines,
      pause,
      speed,
      debug
    } = this.state;
    return (
      <View style={styles.container}>
        <DebugView debug={{ ...debug, speed, polylines }} />
        <DisplayView time={time} steps={steps} distance={distance.toFixed(2)}>
          <ControlBar
            onChange={this.onChange.bind(this, pause)}
            paused={pause}
          />
        </DisplayView>
        <MapView
          region={region}
          polylines={polylines}
          followsUserLocation={true}
        />
      </View>
    );
  }
}
