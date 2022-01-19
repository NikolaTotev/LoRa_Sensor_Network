using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Services
{
    public class DateService
    {
        public DateTime GetUTCDate()
        {
            DateTime timeUtc = DateTime.UtcNow;
            TimeZoneInfo cstZone = TZConvert.GetTimeZoneInfo("FLE Standard Time");
            DateTime cstTime = TimeZoneInfo.ConvertTimeFromUtc(timeUtc, cstZone);
            return cstTime;
        }
    }
}
