using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class RxMetadata
    {
        public GatewayIDs gateway_ids;
        public string time;
        public string timestamp;
        public int rssi;
        public int channel_rssi;
        public float snr;
        public string uplink_token;
        public int channel_index;
    }
}
