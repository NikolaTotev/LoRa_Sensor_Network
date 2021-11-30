using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    [JsonObject(MemberSerialization.OptIn)]
    public class Settings
    {
        [JsonProperty("data_rate")]
        public DataRate data_rate { get; set; }

        [JsonProperty("coding_rate")]
        public string coding_rate { get; set; }

        [JsonProperty("frequency")]
        public string frequency { get; set; }

        [JsonProperty("timestamp")]
        public string timestamp { get; set; }

        [JsonProperty("time")]
        public string time { get; set; }
    }
}
