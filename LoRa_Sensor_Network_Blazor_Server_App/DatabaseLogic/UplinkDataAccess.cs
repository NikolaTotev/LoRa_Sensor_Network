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
        public UplinkDataAccess()
        {
            InsertSensorReading();
        }

        public void InsertSensorReading()
        {
            ConfigurationManager manager = new ConfigurationManager();
            string conString = manager.GetConnectionString("LoraDB");
            using (SqlConnection connection = new SqlConnection(conString))
            {
                connection.Execute("insert into uplinkdata (uplinkID, uplinkData) values (1, testData)");
            }
        }
    }
}
