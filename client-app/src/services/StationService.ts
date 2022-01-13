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

class StationService {
  async getStationReadings() {
    return httpService.get<LatestSensorReading>('api/SensorReadings');
  }

  async getStationList() {
    return httpService.get<Station[]>('api/GetStationList');
  }
}

const stationService = new StationService();
export default stationService;
