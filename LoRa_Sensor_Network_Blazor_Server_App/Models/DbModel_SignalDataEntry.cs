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
        public float snr;
        public int spreadingFactor;
        public bool confirmed;
        public string bandID;
        public string clusterID;
        public string tenantID;
        public string consumedAirtime;
        public string gateway;
        //DO NOT CHANGE PROPERTY NAMES!

        public DbModel_SignalDataEntry(string entryId, string relatedSensorData, string sessionKeyId, int rssi, float snr, int spreadingFactor, bool confirmed, string bandId, string clusterId, string tenantId, string consumedAirtime, string gateway)
        {
            entryID = entryId;
            this.relatedSensorData = relatedSensorData;
            sessionKeyID = sessionKeyId;
            this.rssi = rssi;
            this.snr = snr;
            this.spreadingFactor = spreadingFactor;
            this.confirmed = confirmed;
            bandID = bandId;
            clusterID = clusterId;
            tenantID = tenantId;
            this.consumedAirtime = consumedAirtime;
            this.gateway = gateway;
        }
    }
}
