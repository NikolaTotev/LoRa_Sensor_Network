using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic;
using LoRa_Sensor_Network_Blazor_Server_App.Models;

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
            List<DbModel_BasicStationInfo> stations = m_StationInfoDataAccess.GetEntriesListOfStations();


        }
    }
}
