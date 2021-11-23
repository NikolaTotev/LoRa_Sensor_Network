using System;

namespace BasicTCP_Server
{
    class Program
    {
        static void Main(string[] args)
        {
            TCP_Server server = new TCP_Server();
            bool stopFlag = false;

            server.ServerNotification += DisplayMessage;
            server.StartServer();

            while (!stopFlag)
            {
                string debugInput = Console.ReadLine();
                Console.WriteLine(debugInput);
                if (debugInput == "STOP")
                {
                    server.StopServer();
                    stopFlag = true;
                }
            }

        }
        public static void DisplayMessage(string message)
        {
            Console.WriteLine(message);
        }
    }
}
