using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class ApiModel_BasicLatestSensorReadings
    {
        public double averageTemperature { get; set; }

        public ApiModel_BasicLatestSensorReadings(double avgTemp)
        {
            averageTemperature = avgTemp;
        }
    }
}
