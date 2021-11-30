using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.Data;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using Microsoft.Extensions.Configuration;
using ConfigurationManager = Microsoft.Extensions.Configuration.ConfigurationManager;
using JsonSerializer = Newtonsoft.Json.JsonSerializer;


namespace LoRa_Sensor_Network_Blazor_Server_App.WebHookHandlers
{
    [Microsoft.AspNetCore.Mvc.Route("ttnhooks/[controller]")]
    [ApiController]
    public class SensorUplinkHandlerController : ControllerBase
    {
        private WeatherForecastService m_TempService;
        public SensorUplinkHandlerController(WeatherForecastService service)
        {
            m_TempService = service;
        }

        [HttpPost]
        public void ProcessUplink([FromBody] dynamic data)
        {
            LoRaUplink uplinkData = ToObject<LoRaUplink>(data);
            int a = 0;
        }

        public static T ToObject<T>(JsonElement element)
        {
            var json = element.GetRawText();
            return Newtonsoft.Json.JsonConvert.DeserializeObject<T>(json);
            
        }

        public string uplinkData;
    }
}
