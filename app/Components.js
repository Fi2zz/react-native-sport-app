import React from "react";
import { Image, StyleSheet, Text, TouchableOpacity, View } from "react-native";
import {
  AppStyle,
  MapStyle,
  DisplayStyle,
  ActionerStyle,
  InfoStyle
} from "./styles";
import MapContainer, { Polyline, Marker } from "react-native-maps";
import SafeAreaView from "react-native-safe-area-view";
import { DELTA } from "./utils";

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
  const { polylines, heading, coordinate } = props;
  if (!coordinate.latitude || !coordinate.longitude) {
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
      initialRegion={{ ...coordinate, ...DELTA }}
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

export function InfoView({ latitude, longitude, altitude, accuracy }) {
  return (
    <View style={InfoStyle.container}>
      <SafeAreaView forceInset={{ top: "always" }}>
        <Text style={InfoStyle.label}>
          {altitude} m / h:
          {accuracy.horizontal} / v:
          {accuracy.vertical}
        </Text>
        <Text style={InfoStyle.label}>
          lat: {latitude} / lng:
          {longitude}
        </Text>
      </SafeAreaView>
    </View>
  );
}

export function LocationMarker({ rotation }) {
  return (
    <View>
      <Image
        source={require("./assets/icon-location.png")}
        style={{
          width: 24,
          height: 24,
          transform: [{ rotate: `${rotation}` }]
        }}
      />
    </View>
  );
}
