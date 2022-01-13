using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class DbModel_BasicStationInfo
    {
        //DO NOT CHANGE PROPERTY NAMES!
        public string stationID { get; set; }
        public string stationName { get; set; }
        public double longitude { get; set; }
        public double latitude { get; set; }
        public DateTime lastSeen { get; set; }
        //DO NOT CHANGE PROPERTY NAMES!
    }
}
