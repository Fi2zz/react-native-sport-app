import React, { Component } from "react";
import { Animated, Image } from "react-native";
import {
  InfoView,
  DisplayView,
  MapView,
  Actioner,
  AppContainer,
  LocationMarker
} from "./Components";
import { Sport } from "./SportModule";
import { Timer } from "./Timer";
export default class App extends Component {
  state = {
    steps: 0,
    polylines: [],
    distance: 0.0,
    time: "00:00:00",
    coordinate: {},
    altitude: 0.0,
    task: {
      stopped: true,
      pause: true,
      reset: false
    },
    accuracy: {
      vertical: 0,
      horizontal: 0
    },
    heading: 0.0
  };

  componentDidMount() {
    this.create();
  }
  create() {
    try {
      Sport.addListener("walk", data => {
        this.setState({
          steps: data.steps + this.state.steps
        });
      });

      Sport.addListener("locationUpdated", data => {
        const { coordinate, distance, accuracy } = data;
        const { polylines } = this.state;
        this.setState({
          polylines: [...polylines, coordinate],
          distance,
          coordinate,
          accuracy
        });
      });
      Sport.start();
    } catch (e) {}
  }

  onChange() {
    let shouldPaused = !this.state.task.pause;
    if (shouldPaused) {
      Sport.stop(() =>
        this.setState({
          task: {
            stopped: false,
            pause: true
          }
        })
      );
      Timer.pause();
    } else {
      Sport.start(() => {
        Timer.start(display => {
          this.setState({
            time: display,
            task: {
              stopped: false,
              pause: false
            }
          });
        });
      });
    }
  }
  render() {
    const {
      time,
      steps,
      distance,
      polylines,
      pause,
      task,
      coordinate,
      altitude,
      accuracy,
      heading
    } = this.state;
    return (
      <AppContainer>
        <InfoView
          latitude={coordinate.latitude}
          longitude={coordinate.longitude}
          altitude={(altitude + accuracy.vertical).toFixed(2)}
          accuracy={accuracy}
          heading={heading}
        />
        <DisplayView time={time} steps={steps} distance={distance.toFixed(2)}>
          <Actioner
            onChange={this.onChange.bind(this, pause)}
            paused={task.pause}
          />
        </DisplayView>
        <MapView coordinate={coordinate} polylines={polylines} />
      </AppContainer>
    );
  }
}
