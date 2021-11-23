using System;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using ALoRa.Library;
using MQTTnet;
using MQTTnet.Client;
using MQTTnet.Client.Options;
using MQTTnet.Client.Subscribing;

namespace MQTT_Console_Test
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nALoRa ConsoleApp - A The Things Network C# Library\n");

            var app = new TTNApplication("lora-sensor-mesh-stack-test", "E2M5LEHSSON5W2NGGXFTTPMHXBC7MI3LVKHBEGY", "eu");
            app.MessageReceived += App_MessageReceived;

            Console.WriteLine("Press return to exit!");
            Console.ReadLine();

            app.Dispose();

            Console.WriteLine("\nAloha, Goodbye, Vaarwel!");

            System.Threading.Thread.Sleep(1000);
        }

        private static void App_MessageReceived(TTNMessage obj)
        {
            var data = BitConverter.ToString(obj.Payload);
            Console.WriteLine($"Message Timestamp: {obj.Timestamp}, Device: {obj.DeviceID}, Topic: {obj.Topic}, Payload: {data}");
        }
    }
}
