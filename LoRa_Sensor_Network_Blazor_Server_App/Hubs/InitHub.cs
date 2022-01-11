﻿using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LoRa_Sensor_Network_Blazor_Server_App.Hubs
{
    public class InitHub: Hub
    {
        public async override Task OnConnectedAsync()
        {
            await base.OnConnectedAsync();
            await Clients.Caller.SendAsync("SetClientMessage", "Connected successfully!");
        }

        public async Task SendConnectionId(string connectionId)
        {
            await Clients.All.SendAsync("SetClientMessage", "A connection with ID '" + connectionId + "' has just connected");
        }
    }
}