using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.Data;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using LoRa_Sensor_Network_Blazor_Server_App.Services;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using ConfigurationManager = Microsoft.Extensions.Configuration.ConfigurationManager;
using JsonSerializer = Newtonsoft.Json.JsonSerializer;


namespace LoRa_Sensor_Network_Blazor_Server_App.WebHookHandlers
{
    [Microsoft.AspNetCore.Mvc.Route("webhookhandlers/[controller]")]
    [ApiController]
    public class SensorUplinkHandlerController : ControllerBase
    {
        private UplinkDataService m_DataService;
        public SensorUplinkHandlerController(UplinkDataService service)
        {
            m_DataService = service;
        }

        [HttpPost]
        public void ProcessUplink([FromBody] dynamic data)
        {
            LoRaUplink uplinkData = ToObject<LoRaUplink>(data);
            string jsonString = data.ToString();
            dynamic DeserData = JsonConvert.DeserializeObject(jsonString);
            var uplinkMsk = DeserData.data.uplink_message;
            m_DataService.ProcessUplink(uplinkData);
        }

        public static T ToObject<T>(JsonElement element)
        {
            var json = element.GetRawText();
            return Newtonsoft.Json.JsonConvert.DeserializeObject<T>(json);
            
        }
    }
}
