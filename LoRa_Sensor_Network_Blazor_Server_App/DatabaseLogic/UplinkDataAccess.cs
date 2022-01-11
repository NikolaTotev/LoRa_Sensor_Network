using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using System.Data.SqlClient;
using Dapper;
using LoRa_Sensor_Network_Blazor_Server_App.UtilityClasses;
using Microsoft.Extensions.Configuration;


namespace LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic
{
    public class UplinkDataAccess
    {
        private readonly IConfiguration m_Configuration;
        private string connectionString;

        public UplinkDataAccess(IConfiguration config)
        {
            m_Configuration = config;
            connectionString = m_Configuration.GetConnectionString("LoraDB");
        }
        
        public void AddEntrySensorReading(DbModel_SensorReadingEntry entry)
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "dbo.spSensorData_AddEntrySensorReading @readingID, @originID, @payload, @timeOfCapture",
                    new
                    {
                        readingID = entry.readingID,
                        originID = entry.originID,
                        payload = entry.payload,
                        timeOfCapture = entry.timeOfCapture
                    });
            }
        }

        public void AddEntrySignalData(DbModel_SignalDataEntry entry)
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "dbo.spSignalData_AddEntrySignalData @entryID, @relatedSensorData, @sessionKeyID, @rssi,@snr, @spreadingFactor, @confirmed, @bandID, @clusterID, @tenantID, @consumedAirtime, @gateway",
                    new
                    {
                        entryID = entry.entryID,
                        relatedSensorData = entry.relatedSensorData,
                        sessionKeyID = entry.sessionKeyID,
                        rssi = entry.rssi,
                        snr = entry.snr,
                        spreadingFactor = entry.spreadingFactor,
                        confirmed = entry.confirmed,
                        bandID = entry.bandID,
                        clusterID = entry.clusterID,
                        tenantID = entry.tenantID,
                        consumedAirtime = entry.consumedAirtime,
                        gateway = entry.gateway
                    });
            }
        }

        public void UpdateFieldStationLastSeen(string id)
        {
            using (IDbConnection connection = new SqlConnection(connectionString))
            {
                DateTime timeUtc = DateTime.UtcNow;
                TimeZoneInfo cstZone = TimeZoneInfo.FindSystemTimeZoneById("FLE Standard Time");
                DateTime cstTime = TimeZoneInfo.ConvertTimeFromUtc(timeUtc, cstZone);

                connection.Execute(
                    "dbo.spStations_UpdateFieldStationLastSeen @lastSeen, @StationID",
                    new
                    {
                        lastSeen = cstTime,
                        StationID = id
                    });
            }
        }
    }
}
