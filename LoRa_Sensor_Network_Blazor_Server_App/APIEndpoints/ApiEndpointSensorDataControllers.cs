using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using LoRa_Sensor_Network_Blazor_Server_App.Services;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.APIEndpoints
{
    [Route("api/[controller]")]
    [ApiController]
    public class SensorReadingsController : ControllerBase
    {
        private SensorReadingsDataAccess m_SensorReadingDbAccess;
        private StationInfoDataAccess m_StationInfoDbAccess;
        private DataProcessingService m_DataProcessing;

        public SensorReadingsController(SensorReadingsDataAccess db, StationInfoDataAccess stationDb, DataProcessingService dataProcessing)
        {
            m_SensorReadingDbAccess = db;
            m_StationInfoDbAccess = stationDb;
            m_DataProcessing = dataProcessing;
        }

        [HttpGet]
        public ApiModel_BasicLatestSensorReadings Get()
        {
            List<DbModel_SensorReadingEntry> latestSensorReadings =
                m_SensorReadingDbAccess.GetEntriesLatestSensorReadingsAllStations(m_StationInfoDbAccess);


            List<string> listOfTemperatures = m_DataProcessing.ExtractListOfValuesFromListOfReading(latestSensorReadings, "temperature");

            List<string> listOfHumidities = m_DataProcessing.ExtractListOfValuesFromListOfReading(latestSensorReadings, "humid");

            double avgTemp = m_DataProcessing.GenerateAvgFromList(listOfTemperatures);
            double avgHumidities = m_DataProcessing.GenerateAvgFromList(listOfHumidities);

            ApiModel_BasicLatestSensorReadings data = new ApiModel_BasicLatestSensorReadings(avgTemp);
         
            return data;
        }
    }

    [Route("api/[controller]")]
    [ApiController]
    public class StationSensorReadingsWindowedController : ControllerBase
    {
        private SensorReadingsDataAccess m_SensorReadingDbAccess;
    
        public StationSensorReadingsWindowedController(SensorReadingsDataAccess db)
        {
            m_SensorReadingDbAccess = db;
        }

        [HttpGet]
        public List<DbModel_SensorReadingEntry> Get(string startDate, string endDate, string stationID)
        {
            DateTime start = DateTime.Parse(startDate);
            DateTime end = DateTime.Parse(endDate);
            List<DbModel_SensorReadingEntry> sensorReadings =
                m_SensorReadingDbAccess.GetEntriesSensorReadingsByStationIDWindowed(stationID, start, end);

            return sensorReadings;
        }
    }
}
