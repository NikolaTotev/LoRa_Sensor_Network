using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    [JsonObject(MemberSerialization.OptIn)]
    public class RxMetadata
    {
        [JsonProperty("gateway_id")]
        public GatewayIDs gateway_ids { get; set; }

        [JsonProperty("time")]
        public string time { get; set; }

        [JsonProperty("timestamp")]
        public string timestamp { get; set; }

        [JsonProperty("rssi")]
        public int rssi { get; set; }

        [JsonProperty("channel_rssi")]
        public int channel_rssi { get; set; }

        [JsonProperty("snr")]
        public float snr { get; set; }

        [JsonProperty("uplink_token")]
        public string uplink_token { get; set; }

        [JsonProperty("channel_index")]
        public int channel_index { get; set; }
    }
}
