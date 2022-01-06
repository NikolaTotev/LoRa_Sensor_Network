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
    public class StationInfoDataAccess
    {
        private readonly IConfiguration m_Configuration;
        private string connectionString;

        public StationInfoDataAccess(IConfiguration config)
        {
            m_Configuration = config;
            connectionString = m_Configuration.GetConnectionString("LoraDB");

        }

        //Get the list of available stations;
        public List<DbModel_BasicStationInfo> GetEntriesListOfStations()
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query<DbModel_BasicStationInfo>(
                    "dbo.spStations_GetEntriesListOfStations").ToList();
            }
        }

        //Get a list of supported measurements by a given station using a station ID;
        public string GetEntryAvailableMeasurementsByStationID(string id)
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query<string>(
                    "dbo.spStations_GetEntryAvailableMeasurementsByStationID @stationID", new { stationID = id }).First();
            }
        }

        //Get all of the information about a station using a station ID;
        public StationInfoDataAccess GetEntryFullStationInfoByStationID(string id)
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query<StationInfoDataAccess>(
                    "dbo.spStations_GetEntryFullStationInfoByStationID @stationID", new { stationID = id }).First();
            }
        }
    }
}
