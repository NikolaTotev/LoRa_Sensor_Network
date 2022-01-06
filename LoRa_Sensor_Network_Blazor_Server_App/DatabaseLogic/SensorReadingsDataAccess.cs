using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
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
        public List<string> GetEntriesSensorReadingsByStationIDWindowed()
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {

            }
        }

        //Gets all of the readings from all of the stations using a given window.
        //The time Window is defined by start and end date. A single date can be chosen by setting startDate = endDate;
        public void GetEntriesSensorReadingsWindowed()
        {

        }

        //Gets only the latest sensor reading from a station using the station ID;
        public void GetEntryLatestSensorReadingByStationID()
        {

        }
        
        //Gets only the latest readings from all of the stations ;
        public void GetEntriesLatestSensorReadingsAllStations()
        {

        }


        //Gets a list of measurements from the station using the list of strings and the provided station id;
        //The Window is defined by start and end date. A single date can be chosen by setting startDate = endDate;
        public void GetEntriesListOfMeasurementsByDateAndStationIDWindowed()
        {

        }
    }
}
