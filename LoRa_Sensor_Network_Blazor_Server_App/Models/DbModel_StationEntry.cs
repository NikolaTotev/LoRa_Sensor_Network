using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class DbModel_StationEntry
    {
        //DO NOT CHANGE PROPERTY NAMES!
        public string stationID { get; set; }
        public string joinEUI { get; set; }
        public string devAddr { get; set; }
        public string stationName { get; set; }
        public double longitude { get; set; }
        public double latitude { get; set; }
        public int numberOfMessages { get; set; }
        public DateTime lastSeen { get; set; }
        public string supportedMeasurements { get; set; }
        public string dateCreated { get; set; }
        //DO NOT CHANGE PROPERTY NAMES!

        public DbModel_StationEntry()
        {
            
        }

        public DbModel_StationEntry(string stationId, string joinEui, string devAddr, string stationName, double longitude, double latitude, int numberOfMessages, DateTime lastSeen, string supportedMeasurements, string dateCreated)
        {
            stationID = stationId;
            joinEUI = joinEui;
            this.devAddr = devAddr;
            this.stationName = stationName;
            this.longitude = longitude;
            this.latitude = latitude;
            this.numberOfMessages = numberOfMessages;
            this.lastSeen = lastSeen;
            this.supportedMeasurements = supportedMeasurements;
            this.dateCreated = dateCreated;
        }
    }
}
