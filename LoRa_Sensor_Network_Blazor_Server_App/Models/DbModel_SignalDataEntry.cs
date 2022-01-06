using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class DbModel_SignalDataEntry
    {
        //DO NOT CHANGE PROPERTY NAMES!
        public string entryID;
        public string relatedSensorData;
        public string sessionKeyID;
        public int rssi;
        public int snr;
        public int spreadingFactor;
        public bool confirmed;
        public string bandID;
        public string clusterID;
        public string tennantID;
        public string consumedAirtime;
        public string gateway;
        //DO NOT CHANGE PROPERTY NAMES!
    }
}
