using LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using LoRa_Sensor_Network_Blazor_Server_App.Services;
using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Hubs
{
    public class SocketHub: Hub
    {
        private SensorReadingsDataAccess m_SensorReadingDbAccess;
        private StationInfoDataAccess m_StationInfoDbAccess;
        private DataProcessingService m_DataProcessing;
        private DateService m_DateService;

        public SocketHub(SensorReadingsDataAccess db, StationInfoDataAccess stationDb, DataProcessingService dataProcessing, DateService dateService)
        {
            m_SensorReadingDbAccess = db;
            m_StationInfoDbAccess = stationDb;
            m_DataProcessing = dataProcessing;
            m_DateService = dateService;
        }

        public async override Task OnConnectedAsync()
        {
            await base.OnConnectedAsync();
            await SendAverageData();
        }

        public async Task SendAverageData()
        {
            List<DbModel_SensorReadingEntry> latestSensorReadings =
               m_SensorReadingDbAccess.GetEntriesLatestSensorReadingsAllStations(m_StationInfoDbAccess);


            List<string> listOfTemperatures = m_DataProcessing.ExtractListOfValuesFromListOfReading(latestSensorReadings, "temperature");

            List<string> listOfHumidities = m_DataProcessing.ExtractListOfValuesFromListOfReading(latestSensorReadings, "humidity");

            double avgTemp = m_DataProcessing.GenerateAvgFromList(listOfTemperatures);
            double avgHumid = m_DataProcessing.GenerateAvgFromList(listOfHumidities);

            ApiModel_BasicLatestSensorReadings data = new ApiModel_BasicLatestSensorReadings(avgTemp, avgHumid, m_DateService.GetUTCDate());

            await Clients.All.SendAsync("SetAverageData", data);
        }

        public async Task SendLatestReading(string stationID)
        {
            DbModel_SensorReadingEntry sensorReading =
                m_SensorReadingDbAccess.GetEntryLatestSensorReadingByStationID(stationID);

            await Clients.All.SendAsync("SetLatestReading", sensorReading);
        }
    }
}
