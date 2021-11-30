using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    [JsonObject(MemberSerialization.OptIn)]
    public class LoRaUplink
    {
        [JsonProperty("end_device_ids")]
        public EndDeviceIDs end_device_ids;

        [JsonProperty("correlation_ids")]
        public List<string> correlation_ids = new List<string>();

        [JsonProperty("received_at")]
        public string received_at { get; set; }

        [JsonProperty("uplink_message")]
        public UplinkMessage uplink_message;
    }
}
