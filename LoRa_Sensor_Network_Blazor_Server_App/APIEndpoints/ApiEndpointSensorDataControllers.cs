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

    /// <summary>
    /// route: /api/SensorReadings
    /// return data: ApiModel_BasicLatestSensorReadings
    /// use: Used to get the latest average temperature and humidity from the sensor network.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class SensorReadingsController : ControllerBase
    {
        private SensorReadingsDataAccess m_SensorReadingDbAccess;
        private StationInfoDataAccess m_StationInfoDbAccess;
        private DataProcessingService m_DataProcessing;
        private DateService m_DateService;

        public SensorReadingsController(SensorReadingsDataAccess db, StationInfoDataAccess stationDb, DataProcessingService dataProcessing, DateService dateService)
        {
            m_SensorReadingDbAccess = db;
            m_StationInfoDbAccess = stationDb;
            m_DataProcessing = dataProcessing;
            m_DateService = dateService;
        }

        [HttpGet]
        public ApiModel_BasicLatestSensorReadings Get()
        {
            List<DbModel_SensorReadingEntry> latestSensorReadings =
                m_SensorReadingDbAccess.GetEntriesLatestSensorReadingsAllStations(m_StationInfoDbAccess);


            List<string> listOfTemperatures = m_DataProcessing.ExtractListOfValuesFromListOfReading(latestSensorReadings, "temperature");

            List<string> listOfHumidities = m_DataProcessing.ExtractListOfValuesFromListOfReading(latestSensorReadings, "humidity");

            double avgTemp = m_DataProcessing.GenerateAvgFromList(listOfTemperatures);
            double avgHumid = m_DataProcessing.GenerateAvgFromList(listOfHumidities);

            ApiModel_BasicLatestSensorReadings data = new ApiModel_BasicLatestSensorReadings(avgTemp, avgHumid,m_DateService.GetUTCDate());
         
            return data;
        }
    }

    /// <summary>
    /// route: /api/StationSensorReadingsWindowed
    /// parameters: string startDate, string endDate, string stationID
    /// return data: List<DbModel_SensorReadingEntry>
    /// use: Used to get a list of sensor readings from a specific station defined by stationID
    /// that fall into the window defined by startDate and endDate.
    /// </summary>
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

    /// <summary>
    /// route: /api/StationSensorReadingsWindowed
    /// parameters: string stationID
    /// return data: DbModel_SensorReadingEntry
    /// use: Used to get the latest sensor reading from a specific station defined by stationID.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class GetLatestStationReadingsController : ControllerBase
    {
        private SensorReadingsDataAccess m_SensorReadingDbAccess;

        public GetLatestStationReadingsController(SensorReadingsDataAccess db)
        {
            m_SensorReadingDbAccess = db;
        }

        [HttpGet]
        public DbModel_SensorReadingEntry Get(string stationID)
        {
         DbModel_SensorReadingEntry sensorReading =
                m_SensorReadingDbAccess.GetEntryLatestSensorReadingByStationID(stationID);

            return sensorReading;
        }

    }
}
