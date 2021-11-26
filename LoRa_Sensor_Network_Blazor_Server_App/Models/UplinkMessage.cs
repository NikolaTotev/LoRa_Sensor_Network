using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Models
{
    public class UplinkMessage
    {
        public string session_key_id;
        public int f_port;
        public int f_cnt;
        public string frm_payload;
        public Dictionary<string, string> decoded_payload;
    }
}
