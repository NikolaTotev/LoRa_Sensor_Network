using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using LoRa_Sensor_Network_Blazor_Server_App.Services;

namespace LoRa_Sensor_Network_Blazor_Server_App.APIEndpoints
{
    [Route("api/[controller]")]
    [ApiController]
    public class SensorReadingsController : ControllerBase
    {
        private SensorReadingsDataAccess m_SensorReadingDbAccess;
        private StationInfoDataAccess m_StationInfoDbAccess;
        private DataProcessingService m_DataProcessing;

        public SensorReadingsController(SensorReadingsDataAccess db, StationInfoDataAccess stationDb)
        {
            m_SensorReadingDbAccess = db;
            m_StationInfoDbAccess = stationDb;
        }

        [HttpGet]
        public ApiModel_BasicLatestSensorReadings Get()
        {
            List<DbModel_SensorReadingEntry> latestSensorReadings =
                m_SensorReadingDbAccess.GetEntriesLatestSensorReadingsAllStations(m_StationInfoDbAccess);


            List<string> listOfTemperatures = m_DataProcessing.ExtractListOfValuesFromListOfReading(latestSensorReadings, "temp");

            List<string> listOfHumidities = m_DataProcessing.ExtractListOfValuesFromListOfReading(latestSensorReadings, "humid");

            double avgTemp = m_DataProcessing.GenerateAvgFromList(listOfTemperatures);
            double avgHumidities = m_DataProcessing.GenerateAvgFromList(listOfHumidities);

            ApiModel_BasicLatestSensorReadings data = new ApiModel_BasicLatestSensorReadings();

            return data;
        }
    }
}
