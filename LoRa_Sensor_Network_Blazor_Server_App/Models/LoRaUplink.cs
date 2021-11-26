using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class LoRaUplink
    {
        public EndDeviceIDs end_device_ids;
        public List<string> correlation_ids;
        public string sent_at;
        public UplinkMessage uplink_message;
        public List<RxMetadata> rx_metadata;


        public string received_at;
        public bool confirmed;
        public string consumed_airtime;
        public VersionIDs version_ids;
        public NetworkIDs network_ids;
    }
}
