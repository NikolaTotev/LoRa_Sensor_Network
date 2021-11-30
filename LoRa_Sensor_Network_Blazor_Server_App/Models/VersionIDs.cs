using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class VersionIDs
    {
        [JsonProperty("brand_id")]
        public string brand_id { get; set; }

        [JsonProperty("model_id")]
        public string model_id { get; set; }

        [JsonProperty("hardware_version")]
        public string hardware_version { get; set; }

        [JsonProperty("firmware_version")]
        public string firmware_version { get; set; }

        [JsonProperty("band_id")]
        public string band_id { get; set; }
    }
}
