using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic;
using LoRa_Sensor_Network_Blazor_Server_App.Models;

namespace LoRa_Sensor_Network_Blazor_Server_App.APIEndpoints
{
    /// <summary>
    /// route: /api/GetStationList
    /// return data: List<DbModel_StationEntry>
    /// use: Used to get a list of all available stations. Full station data is returned.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class GetStationListController : ControllerBase
    {
        private StationInfoDataAccess m_StationInfoDataAccess;

        public GetStationListController(StationInfoDataAccess db)
        {
            m_StationInfoDataAccess = db;
        }

        [HttpGet]
        public List<DbModel_StationEntry> Get()
        {
            List<DbModel_StationEntry> listOfStations = m_StationInfoDataAccess.GetEntriesListOfStations();

            return listOfStations;
        }
    }
}
