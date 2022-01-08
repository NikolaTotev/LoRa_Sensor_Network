using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.Models;
using Newtonsoft.Json;

namespace LoRa_Sensor_Network_Blazor_Server_App.Services
{
    public class DataProcessingService
    {

        public double GenerateAvgFromList(List<double> data)
        {
            double tempSum = 0;

            foreach (double entry in data)
            {
                tempSum += entry;
            }

            return tempSum / data.Count;
        }

        public double GenerateAvgFromList(List<int> data)
        {
            double tempSum = 0;

            foreach (double entry in data)
            {
                tempSum += entry;
            }

            return tempSum / data.Count;
        }

        public double GenerateAvgFromList(List<string> data)
        {
            double tempSum = 0;

            foreach (string entry in data)
            {
                double convertedEntry = 0;
                Double.TryParse(entry, out convertedEntry);
                tempSum += convertedEntry;
            }

            return tempSum / data.Count;
        }

        public Dictionary<string, string> PayloadProcessor(string payloadInJsonStringFmt)
        {
            return JsonConvert.DeserializeObject<Dictionary<string, string>>(payloadInJsonStringFmt);
        }

        public List<string> ExtractListOfValuesFromListOfReading(List<DbModel_SensorReadingEntry> readings, string value)
        {
            List<string> result = new List<string>();

            foreach (DbModel_SensorReadingEntry reading in readings)
            {
                Dictionary<string, string> dictionary = PayloadProcessor(reading.payload);

                if (dictionary.ContainsKey($"{value}"))
                {
                    result.Add(dictionary[$"{value}"]);
                }
            }

            return result;
        }
    }
}
