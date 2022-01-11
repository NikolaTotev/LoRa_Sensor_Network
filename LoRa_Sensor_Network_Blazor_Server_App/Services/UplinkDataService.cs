using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Services
{
    public class UplinkDataService
    {
        private UplinkDataAccess m_UplinkDataAcces;
        private SensorReadingsDataAccess m_SensorReadingsDataAccess;
        private StationInfoDataAccess m_StationInfoDataAccess;

        public UplinkDataService(UplinkDataAccess uplinkDataAccess, SensorReadingsDataAccess sensorReadingsDataAccess, StationInfoDataAccess stationInfoDataAccess)
        {
            m_UplinkDataAcces = uplinkDataAccess;
            m_SensorReadingsDataAccess = sensorReadingsDataAccess;
            m_StationInfoDataAccess = stationInfoDataAccess;
        }

        public void ProcessUplink(LoRaUplink uplink)
        {
            List<string> stations = m_StationInfoDataAccess.GetEntriesListOfStationIDs();

            string uplinkOrigin = uplink.end_device_ids.device_id;

            //Add the station of origin if the station isn't already added;
            if (!stations.Contains(uplinkOrigin))
            {
                double longitude = 0;
                double latitude = 0;

                Double.TryParse(uplink.uplink_message.locations.user.longitude, out longitude);
                Double.TryParse(uplink.uplink_message.locations.user.latitude, out latitude);

                DbModel_StationEntry newStationEntry = new DbModel_StationEntry(
                    stationId: uplink.end_device_ids.device_id,
                    joinEui: uplink.end_device_ids.join_eui,
                    devAddr: uplink.end_device_ids.dev_addr,
                    stationName: $"Station-{stations.Count + 1}",
                    longitude: longitude,
                    latitude: latitude,
                    numberOfMessages: 1,
                    lastSeen: DateTime.Now,
                    supportedMeasurements: JsonConvert.SerializeObject(uplink.uplink_message.decoded_payload.Keys.ToList(), Formatting.Indented),
                    dateCreated: DateTime.Now.ToLongDateString()
                     );

                m_StationInfoDataAccess.AddEntryNewStation(newStationEntry);
            }

            Guid readingGUID = Guid.NewGuid();

            //Add new sensor reading entry;
            string jsonifiedPayload =
                JsonConvert.SerializeObject(uplink.uplink_message.decoded_payload, Formatting.Indented);

            DateTime timeUtc = DateTime.UtcNow;
            TimeZoneInfo cstZone = TimeZoneInfo.FindSystemTimeZoneById("FLE Standard Time");
            DateTime cstTime = TimeZoneInfo.ConvertTimeFromUtc(timeUtc, cstZone);

            DbModel_SensorReadingEntry newEntry = new DbModel_SensorReadingEntry(readingGUID.ToString(), uplink.end_device_ids.device_id, cstTime, jsonifiedPayload);
           
            m_UplinkDataAcces.AddEntrySensorReading(newEntry);

            //Add new signal entry;
            DbModel_SignalDataEntry signalEntry = new DbModel_SignalDataEntry(
                entryId: Guid.NewGuid().ToString(),
                relatedSensorData: readingGUID.ToString(),
                sessionKeyId: uplink.uplink_message.session_key_id,
                rssi: uplink.uplink_message.rx_metadata[0].rssi,
                snr: uplink.uplink_message.rx_metadata[0].snr,
                spreadingFactor: uplink.uplink_message.Settings.data_rate.lora.spreading_factor,
                confirmed: uplink.uplink_message.confirmed,
                bandId: uplink.uplink_message.version_ids.band_id,
                clusterId: uplink.uplink_message.network_ids.cluster_id,
                tenantId: uplink.uplink_message.network_ids.tenant_id,
                consumedAirtime: uplink.uplink_message.consumed_airtime,
                gateway: uplink.uplink_message.rx_metadata[0].gateway_ids.gateway_id);

            m_UplinkDataAcces.AddEntrySignalData(signalEntry);

            m_UplinkDataAcces.UpdateFieldStationLastSeen(uplink.end_device_ids.device_id);
        }
    }
}
