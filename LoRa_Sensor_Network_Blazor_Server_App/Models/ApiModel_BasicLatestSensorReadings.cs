using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class ApiModel_BasicLatestSensorReadings
    {
        public double averageTemperature { get; set; }
        public double averageHumidity { get; set; }
        public string lastUpdate { get; set; }

        public ApiModel_BasicLatestSensorReadings(double avgTemp, double avgHumid)
        {
            averageTemperature = avgTemp;
            averageHumidity = avgHumid;
            lastUpdate = DateTime.Now.ToString();
        }
    }
}
