import httpService from "./HttpService";

export interface LatestSensorReading {
  averageHumidity: string;
  averageTemperature: string;
  lastUpdate: string;
}

export interface Station {
  dateCreated: string; // "Monday, January 10, 2022"
  devAddr: string; // "260BA563"
  joinEUI: string; //"70B3D57ED0032B07"
  lastSeen: string; //"2022-01-13T20:04:08.153"
  latitude: number; //43
  longitude: number; //23
  numberOfMessages: number; //1
  stationID: string; //"eui-a8610a3032306f09"
  stationName: string; //"Station-1"
  supportedMeasurements: string; // "breathVocEquivalent", "co2Equivalent", "humidity", "iaq", "iaqAccuracy", "pressure", "staticIaq","temperature"
}

export interface Reading {
  originID: string; //"eui-a8610a3032306f09"
  payload: string; //"{\r\n  \"breathVocEquivalent\": \"0.53\",\r\n  \"co2Equivalent\": \"517.50\",\r\n  \"humidity\": \"37.82\",\r\n  \"iaq\": \"35.02\",\r\n  \"iaqAccuracy\": \"0\",\r\n  \"pressure\": \"94928.00\",\r\n  \"staticIaq\": \"29.38\",\r\n  \"temperature\": \"20.61\"\r\n}"
  readingID: string; // "b78655e0-5f8f-45f2-aede-1084cecd599a"
  timeOfCapture: Date; //"2022-01-18T00:40:41.697"
}

class StationService {
  async getStationReadings() {
    return httpService.get<LatestSensorReading>('api/SensorReadings');
  }

  async getStationList() {
    return httpService.get<Station[]>('api/GetStationList');
  }

  async getSensorReadingsWindowed(startDate: string, endDate: string, stationId: string) {
    return httpService.get<Reading[]>(`api/StationSensorReadingsWindowed?startDate=${startDate}&endDate=${endDate}&stationId=${stationId}`);
  }
}

const stationService = new StationService();
export default stationService;
