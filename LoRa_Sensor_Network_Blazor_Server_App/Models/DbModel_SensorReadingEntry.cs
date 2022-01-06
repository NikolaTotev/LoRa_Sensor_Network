using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class DbModel_SensorReadingEntry
    {
        //DO NOT CHANGE PROPERTY NAMES!
        public string readingID;
        public string originID;
        public DateTime timeOfCapture;
        public string payload;
        //DO NOT CHANGE PROPERTY NAMES!
    }
}
