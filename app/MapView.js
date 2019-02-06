import React from "react";
import { View, Text } from "react-native";
import { MapStyle as styles } from "./styles";
import MapContainer, { Polyline } from "react-native-maps";

export default function MapView(props) {
  let { polylines, region } = props;
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
      initialRegion={region}
      style={styles.container}
      followsUserLocation={true}
      showsBuildings={true}
    >
      <Polyline coordinates={polylines} strokeColor="#05a571" strokeWidth={8} />
    </MapContainer>
  );
}
