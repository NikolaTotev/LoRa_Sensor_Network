using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    [JsonObject(MemberSerialization.OptIn)]
    public class NetworkIDs
    {
        [JsonProperty("net_id")]
        public string net_id { get; set; }

        [JsonProperty("tenant_id")]
        public string tenant_id { get; set; }

        [JsonProperty("cluster_id")]
        public string cluster_id { get; set; }
    }
}
