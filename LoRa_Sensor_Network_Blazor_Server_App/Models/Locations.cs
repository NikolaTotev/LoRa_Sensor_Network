using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    [JsonObject(MemberSerialization.OptIn)]
    public class Locations
    {
        [JsonProperty("user")]
        public User user { get; set; }
    }
}
