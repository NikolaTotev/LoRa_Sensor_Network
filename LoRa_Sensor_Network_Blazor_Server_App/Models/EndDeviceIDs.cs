using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    [JsonObject(MemberSerialization.OptIn)]
    public class EndDeviceIDs
    {
        [JsonProperty("device_id")]
        public string device_id { get; set; }

        [JsonProperty("application_ids")]
        public Dictionary<string, string> application_ids = new Dictionary<string, string>(); //I'm not sure if this will cause problems later.

        [JsonProperty("dev_eui")]
        public string dev_eui { get; set; }

        [JsonProperty("join_eui")]
        public string join_eui { get; set; }

        [JsonProperty("dev_addr")]
        public string dev_addr { get; set; }
    }
}
