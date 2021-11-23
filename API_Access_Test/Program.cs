using System;
using TTNet.Data;

namespace API_Access_Test
{
    class Program
    {
        static void Main(string[] args)
        {
            var app = new ManagedApp("lora-sensor-mesh-stack-test");
            await app.Start("eu1.cloud.thethings.network", 8883, true, "lora-sensor-mesh-stack-test@ttn", apiKey, autoReconnectDelay);

        }
    }
}


// NNSXS.W4UYZLPWXD6HSPOARDFWLHQ54PUO3YWMSKGWDKY.GHRIQGKNIMRBYWJHSS5GC5B2J4RLHIBVVN322DTNQPRVJ4EISETQ