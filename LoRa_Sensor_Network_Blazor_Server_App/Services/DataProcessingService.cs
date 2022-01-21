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

        //Generate an average value from the items in the list.
        //The idea is for this function to be used with lists of doubles
        //in string format. To void issues a TryParse functions is used;
        public double GenerateAvgFromList(List<string> data)
        {
            double tempSum = 0;

            foreach (string entry in data)
            {
                double convertedEntry = 0;
                Double.TryParse(entry, out convertedEntry);
                tempSum += convertedEntry;
            }

            double avgResult = tempSum / data.Count;
            return Math.Round(avgResult,2);
        }

        //A wrapper for the JsonConvert DeserializeObject function. Makes code using the function more readable.
        public Dictionary<string, string> PayloadProcessor(string payloadInJsonStringFmt)
        {
            return JsonConvert.DeserializeObject<Dictionary<string, string>>(payloadInJsonStringFmt);
        }

        //From a list of sensor readings, extracts the encoded payload, converts it into a dictionary<string,string> and then extracts
        //Values with the key given in the "value" parameter. 
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
