import { Dimensions } from "react-native";
const pad = v => (v > 9 ? v : `0${v}`);

function dateComponents(date) {
  return {
    year: date.getFullYear(),
    month: pad(date.getMonth() + 1),
    date: pad(date.getDate()),
    day: date.getDay(),
    hours: pad(date.getHours()),
    minutes: pad(date.getMinutes()),
    seconds: pad(date.getSeconds()),
    millseconds: pad(date.getMilliseconds())
  };
}

function displayDateWithFormat(input) {
  const { year, month, date, hours, minutes, seconds } = dateComponents(input);
  return `${hours}:${minutes}:${seconds}`;
}

export { displayDateWithFormat };

const { width: screenWidth, height: screenHeight } = Dimensions.get("window");

global.screenWidth = screenWidth;
global.screenHeight = screenHeight;

export { screenWidth, screenHeight };

const ASPECT_RATIO = screenWidth / screenHeight;
const LATITUDE_DELTA = 0.0922;
const LONGITUDE_DELTA = LATITUDE_DELTA * ASPECT_RATIO;
export const DELTA = {
  latitudeDelta: LATITUDE_DELTA,
  longitudeDelta: LONGITUDE_DELTA
};
