import React, { Component } from "react";

import { StyleSheet, View, Text } from "react-native";
import MapContainer, { Polyline } from "react-native-maps";
import { screenHeight, screenWidth } from "./utils";
const ASPECT_RATIO = screenWidth / screenHeight;

const LATITUDE_DELTA = 0.0922;
const LONGITUDE_DELTA = LATITUDE_DELTA * ASPECT_RATIO;
let styles = StyleSheet.create({
  container: {
    width: screenWidth,
    height: screenHeight,
    flex: 1,
    alignItems: "center",
    justifyContent: "center"
  }
});

export default class MapView extends Component {
  render() {
    let { polylines, region } = this.props;

    let initialRegion = {
      ...region,
      latitudeDelta: LATITUDE_DELTA,
      longitudeDelta: LONGITUDE_DELTA
    };

    if (!region.latitude || !region.longitude) {
      return (
        <View style={styles.container}>
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
        initialRegion={initialRegion}
        style={styles.container}
        followsUserLocation={true}
        showsBuildings={true}
      >
        <Polyline
          coordinates={polylines}
          strokeColor="#05a571"
          strokeWidth={6}
        />
      </MapContainer>
    );
  }
}
