using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using System.Data.SqlClient;


namespace LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic
{
    public class UplinkDataAccess
    {

        public void InsertSensorReading(LoRaUplink reading)
        {
            using (SqlConnection connection = new SqlConnection())
            {
            }
        }
    }
}
