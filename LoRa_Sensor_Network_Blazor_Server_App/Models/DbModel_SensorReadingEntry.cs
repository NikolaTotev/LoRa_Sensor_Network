using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class DbModel_SensorReadingEntry
    {
        //DO NOT CHANGE PROPERTY NAMES!
        public string readingID { get; set; }
        public string originID { get; set; }
        public DateTime timeOfCapture { get; set; }
        public string payload { get; set; }
        //DO NOT CHANGE PROPERTY NAMES!

        public DbModel_SensorReadingEntry()
        {

        }

        public DbModel_SensorReadingEntry(string readingId, string originId, DateTime timeOfCapture, string payload)
        {
            readingID = readingId;
            originID = originId;
            this.timeOfCapture = timeOfCapture;
            this.payload = payload;
        }
    }
}
