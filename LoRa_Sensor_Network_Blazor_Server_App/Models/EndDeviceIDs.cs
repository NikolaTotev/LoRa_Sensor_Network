using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class EndDeviceIDs
    {
        public string device_id;
        public Dictionary<string, string> application_ids; //I'm not sure if this will cause problems later.
        public string dev_eui;
        public string join_eui;
        public string dev_addr;
    }
}
