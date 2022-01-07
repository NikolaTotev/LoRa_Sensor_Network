using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class DbModel_StationEntry
    {
        //DO NOT CHANGE PROPERTY NAMES!
        public string stationID;
        public string joinEUI;
        public string devAddr;
        public string stationName;
        public double longitude;
        public double latitude;
        public int numberOfMessages;
        public DateTime lastSeen;
        public string supportedMeasurements;
        public string dateCreated;
        //DO NOT CHANGE PROPERTY NAMES!

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
