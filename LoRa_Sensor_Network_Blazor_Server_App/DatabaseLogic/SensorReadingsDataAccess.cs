using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using Microsoft.Extensions.Configuration;

namespace LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic
{
    public class SensorReadingsDataAccess
    {
        private readonly IConfiguration m_Configuration;
        private string connectionString;

        public SensorReadingsDataAccess(IConfiguration config)
        {
            m_Configuration = config;
            connectionString = m_Configuration.GetConnectionString("LoraDB");
        }

        //Gets all sensor readings in a time window from a station using the station ID;
        //The time Window is defined by start and end date. A single date can be chosen by setting startDate = endDate;
        public List<DbModel_SensorReadingEntry> GetEntriesSensorReadingsByStationIDWindowed(string id, DateTime start, DateTime end)
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query<DbModel_SensorReadingEntry>(
                    "dbo.spSensorData_GetEntriesSensorReadingsByStationIDWindowed @StartDate, @EndDate, @StationID",
                    new { StartDate = start.Date, EndDate=end.Date, StationID = id }).ToList();
            }
        }

        //Gets all of the readings from all of the stations using a given window.
        //The time Window is defined by start and end date. A single date can be chosen by setting startDate = endDate;
        public List<DbModel_SensorReadingEntry> GetEntriesSensorReadingsWindowed(DateTime start, DateTime end)
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query<DbModel_SensorReadingEntry>(
                    "dbo.spSensorData_GetEntriesSensorReadingsWindowed @StartDate, @EndDate", new { StartDate = start, EndDate = end }).ToList();
            }
        }

        //Gets only the latest sensor reading from a station using the station ID;
        public DbModel_SensorReadingEntry GetEntryLatestSensorReadingByStationID(string id)
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                var result = connection.Query<DbModel_SensorReadingEntry>(
                    "dbo.spSensorData_GetEntryLatestSensorReadingByStationID @StationID", new { StationID = id }).ToList().First();
                return result;
            }
        }

        //Gets only the latest readings from all of the stations;
        public List<DbModel_SensorReadingEntry> GetEntriesLatestSensorReadingsAllStations(StationInfoDataAccess stationInfo)
        {
            List<DbModel_BasicStationInfo> ids = stationInfo.GetEntriesListOfStations();

            List<DbModel_SensorReadingEntry> latestData = new List<DbModel_SensorReadingEntry>();

            foreach (DbModel_BasicStationInfo station in ids)
            {
                latestData.Add(GetEntryLatestSensorReadingByStationID(station.stationID));
            }

            return latestData;
        }


        //Gets a list of measurements from the station using the list of strings and the provided station id;
        //The Window is defined by start and end date. A single date can be chosen by setting startDate = endDate;
        public void GetEntriesListOfMeasurementsByDateAndStationIDWindowed()
        {
            //TODO This is an advanced feature and will be left for later.
        }
    }
}
