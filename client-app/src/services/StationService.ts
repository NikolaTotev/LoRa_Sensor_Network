import httpService from "./HttpService";

export interface LatestSensorReading {
  averageHumidity: string;
  averageTemperature: string;
  lastUpdate: string;
}

class StationService {
  async getStationReadings() {
    return httpService.get<LatestSensorReading>('api/SensorReadings');
  }
}

const stationService = new StationService();
export default stationService;
