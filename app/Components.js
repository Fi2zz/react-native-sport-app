import React from "react";
import { Image, StyleSheet, Text, TouchableOpacity, View } from "react-native";
import { AppStyle, MapStyle, DisplayStyle, ActionerStyle } from "./styles";
import MapContainer, { Polyline } from "react-native-maps";
import SafeAreaView from "react-native-safe-area-view";

const source = {
  start: require("./assets/icon-start.png"),
  pause: require("./assets/icon-pause.png"),
  location: require("./assets/icon-location.png"),
  stop: require("./assets/icon-stop.png")
};

export function AppContainer(props) {
  return <View style={AppStyle.container}>{props.children}</View>;
}

export function MapView(props) {
  const { polylines, region } = props;
  if (!region.latitude || !region.longitude) {
    return (
      <View style={MapStyle.container}>
        <Text>Loading</Text>
      </View>
    );
  }
  return (
    <MapContainer
      showsUserLocation={true}
      showsIndoors={true}
      showsScale={true}
      showsCompass={true}
      showsTraffic={true}
      loadingEnabled={true}
      zoomEnabled={true}
      initialRegion={region}
      style={MapStyle.container}
      followsUserLocation={true}
      showsBuildings={true}
    >
      <Polyline coordinates={polylines} strokeColor="#05a571" strokeWidth={8} />
    </MapContainer>
  );
}

export function DisplayView(props) {
  const { distance, steps, time } = props;
  const forceInset = {
    bottom: "always",
    top: "never",
    left: "always",
    right: "always"
  };
  return (
    <View style={DisplayStyle.container}>
      <SafeAreaView forceInset={forceInset}>
        {props.children}
        <View style={DisplayStyle.rowContainer}>
          <View style={DisplayStyle.row}>
            <View style={DisplayStyle.firstItem}>
              <Text style={DisplayStyle.labelText}>步数</Text>
              <Text style={DisplayStyle.text}>{steps}</Text>
            </View>
            <View style={DisplayStyle.centerItem}>
              <Text style={DisplayStyle.labelText}>时间</Text>
              <Text style={DisplayStyle.text}>{time}</Text>
            </View>
            <View style={DisplayStyle.lastItem}>
              <Text style={DisplayStyle.labelText}>距离(km)</Text>
              <Text style={DisplayStyle.text}>{distance}</Text>
            </View>
          </View>
        </View>
      </SafeAreaView>
    </View>
  );
}

export function Actioner(props) {
  const { paused, onChange } = props;
  const icon = paused ? source.start : source.pause;
  return (
    <View style={ActionerStyle.container}>
      <TouchableOpacity
        style={ActionerStyle.iconContainer}
        onPress={() => onChange(paused)}
      >
        <Image source={icon} style={ActionerStyle.iconImage} />
      </TouchableOpacity>
    </View>
  );
}

export function DebugView({ debug }) {
  const { comparation, coordinate, speed, polylines, shouldDispatch } = debug;
  return (
    <View style={AppStyle.counterViewChildrenContainer}>
      <SafeAreaView forceInset={{ top: "always" }}>
        <Text style={AppStyle.debugLabel}>comparation</Text>
        <Text style={AppStyle.debugLabel}>
          lat:
          {comparation.lat} / lng:
          {comparation.lng}
        </Text>
        <Text style={AppStyle.debugLabel}>coordinate</Text>
        <Text style={AppStyle.debugLabel}>
          lat:
          {coordinate.latitude} / lng:
          {coordinate.longitude}
        </Text>
        <Text style={AppStyle.debugLabel}>
          location changed: {shouldDispatch.toString()} / speed:
          {speed} / polylines:
          {polylines.length}
        </Text>
      </SafeAreaView>
    </View>
  );
}
