using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    [JsonObject(MemberSerialization.OptIn)]
    public class GatewayIDs
    {
        [JsonProperty("gateway_id")]
        public string gateway_id { get; set; }
        
        [JsonProperty("eui")]
        public string eui { get; set; }
    }
}
