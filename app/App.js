import React, { Component } from "react";
import {
  DebugView,
  DisplayView,
  MapView,
  Actioner,
  AppContainer
} from "./Components";
import { Sport } from "./SportModule";
import { Timer } from "./Timer";
import { DELTA } from "./utils";
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
    speed: 0.0,
    debug: {
      shouldDispatch: true,
      comparation: {
        lat: null,
        lng: null
      },
      coordinate: {}
    },
    task: {
      stopped: true,
      pause: true,
      reset: false
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
        let { polylines, region } = this.state;

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
      region,
      polylines,
      pause,
      speed,
      debug,
      task
    } = this.state;
    return (
      <AppContainer>
        <DebugView debug={{ ...debug, speed, polylines }} />
        <DisplayView time={time} steps={steps} distance={distance.toFixed(2)}>
          <Actioner
            onChange={this.onChange.bind(this, pause)}
            paused={task.pause}
          />
        </DisplayView>
        <MapView region={region} polylines={polylines} />
      </AppContainer>
    );
  }
}
