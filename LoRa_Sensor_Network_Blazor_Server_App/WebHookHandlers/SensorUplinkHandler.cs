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
            LoRaUplink uplinkData = new LoRaUplink(); //= ToObject<LoRaUplink>(data);
            string jsonString = data.ToString();
            dynamic deserializedObject = JsonConvert.DeserializeObject(jsonString);
            
            var uplinkObjectDynamicForm = deserializedObject.uplink_message;
            string uplinkObjectJsonString = JsonConvert.SerializeObject(uplinkObjectDynamicForm);
            UplinkMessage uplinkMessage = JsonConvert.DeserializeObject<UplinkMessage>(uplinkObjectJsonString);

            var endDeviceIdsDynamicForm = deserializedObject.end_device_ids;
            string endDeviceIdsJsonString = JsonConvert.SerializeObject(endDeviceIdsDynamicForm);
            EndDeviceIDs endDeviceIDs = JsonConvert.DeserializeObject<EndDeviceIDs>(endDeviceIdsJsonString);

            string receivedAt = deserializedObject.received_at.ToString();

            uplinkData.uplink_message = uplinkMessage;
            uplinkData.end_device_ids = endDeviceIDs;
            uplinkData.received_at = receivedAt;
            
            m_DataService.ProcessUplink(uplinkData);
        }

        public static T ToObject<T>(JsonElement element)
        {
            var json = element.GetRawText();
            return Newtonsoft.Json.JsonConvert.DeserializeObject<T>(json);
            
        }
    }
}
