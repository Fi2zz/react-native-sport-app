import { StyleSheet } from "react-native";
import { screenHeight, screenWidth } from "./utils";

export const AppStyle = StyleSheet.create({
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
  },
  counterViewChildrenContainer: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    zIndex: 25,
    padding: 20
    // backgroundColor: "#fff"
  },
  debugLabel: {
    fontSize: 12,
    marginBottom: 2,
    textAlign: "left"
  }
});

export const MapStyle = StyleSheet.create({
  container: {
    width: screenWidth,
    height: screenHeight,
    flex: 1,
    alignItems: "center",
    justifyContent: "center"
  }
});

export const DisplayStyle = StyleSheet.create({
  text: {
    fontSize: 32,
    color: "#222",
    textAlign: "center",
    fontFamily: "Bebas Neue"
  },
  container: {
    position: "absolute",
    left: 0,
    right: 0,
    zIndex: 20,
    bottom: 0,
    paddingHorizontal: 20
  },

  rowContainer: {
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
  firstItem: {
    alignItems: "flex-start",
    justifyContent: "flex-start"
  },
  lastItem: {
    alignItems: "flex-end",
    justifyContent: "flex-end"
  },
  centerItem: {
    alignItems: "center",
    justifyContent: "center"
  }
});