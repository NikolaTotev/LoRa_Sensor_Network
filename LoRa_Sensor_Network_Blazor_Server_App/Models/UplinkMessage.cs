using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    [JsonObject(MemberSerialization.OptIn)]
    public class UplinkMessage
    {
        [JsonProperty("session_key_id")]
        public string session_key_id { get; set; }

        [JsonProperty("f_port")]
        public int f_port { get; set; }

        [JsonProperty("f_cnt")]
        public int f_cnt { get; set; }

        [JsonProperty("frm_payload")]
        public string frm_payload { get; set; }

        [JsonProperty("decoded_payload")]
        public Dictionary<string, string> decoded_payload = new Dictionary<string, string>();

        [JsonProperty("rx_metadata")]
        public List<RxMetadata> rx_metadata = new List<RxMetadata>();

        [JsonProperty("received_at")]
        public string received_at { get; set; }

        [JsonProperty("confirmed")]
        public bool confirmed { get; set; }

        [JsonProperty("consumed_airtime")]
        public string consumed_airtime { get; set; }

        [JsonProperty("settings")]
        public Settings Settings { get; set; }

        [JsonProperty("locations")]
        public Locations locations { get; set; }

        [JsonProperty("version_ids")]
        public VersionIDs version_ids { get; set; }

        [JsonProperty("network_ids")]
        public NetworkIDs network_ids { get; set; }
    }
}
