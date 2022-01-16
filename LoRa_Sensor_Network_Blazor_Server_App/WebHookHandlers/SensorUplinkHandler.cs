﻿using Microsoft.AspNetCore.Mvc;
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
using LoRa_Sensor_Network_Blazor_Server_App.Hubs;

namespace LoRa_Sensor_Network_Blazor_Server_App.WebHookHandlers
{
    [Microsoft.AspNetCore.Mvc.Route("webhookhandlers/[controller]")]
    [ApiController]
    public class SensorUplinkHandlerController : ControllerBase
    {
        private UplinkDataService m_DataService;
        private SocketHub m_SocketHub;

        public SensorUplinkHandlerController(UplinkDataService service, SocketHub hub)
        {
            m_DataService = service;
            m_SocketHub = hub;
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
            m_SocketHub.SendData(); //Izmisli kak da go testvash tva....
        }

        public static T ToObject<T>(JsonElement element)
        {
            var json = element.GetRawText();
            return Newtonsoft.Json.JsonConvert.DeserializeObject<T>(json);
            
        }
    }
}
