using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using System.Data.SqlClient;
using Dapper;
using LoRa_Sensor_Network_Blazor_Server_App.UtilityClasses;
using Microsoft.Extensions.Configuration;


namespace LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic
{
    public class UplinkDataAccess
    {
        private DbConnectionOptions m_Options;
        private readonly IConfiguration m_Configuration;

        public UplinkDataAccess(IConfiguration config)
        {
            m_Configuration = config;
        }

        //This function will just call 
        //Add entry sensor reading
        //Add entry signal data
        //Update field station last seen 
        //This function is here just for clarity.
        public void ProcessUplink()
        {
            ConfigurationManager manager = new ConfigurationManager();
            string conString = m_Configuration.GetConnectionString("LoraDB");
            using (SqlConnection connection = new SqlConnection(conString))
            {
                connection.Execute("insert into uplinkdata (uplinkID) values (1)");
            }
        }


        public void AddEntrySensorReading()
        {

        }

        public void AddEntrySignalData()
        {

        }

        public void UpdateFieldStationLastSeen()
        {

        }
    }
}
