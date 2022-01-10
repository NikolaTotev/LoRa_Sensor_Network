import React, { useEffect, useState } from 'react';
import './App.css';
import * as signalR from "@microsoft/signalr";

function App() {
  const hubConnection = new signalR.HubConnectionBuilder()
    .withUrl("https://localhost:44374/initTry", {
      skipNegotiation: true,
      transport: signalR.HttpTransportType.WebSockets
    })
    .configureLogging(signalR.LogLevel.Information)
    .withAutomaticReconnect()
    .build();
 
  // Starts the SignalR connection
  hubConnection.start().then(a => {
    // Once started, invokes the sendConnectionId in our ChatHub inside our ASP.NET Core application.
    if (hubConnection.connectionId) {
      hubConnection.invoke("sendConnectionId", hubConnection.connectionId);
    }
  });  
 
  const SignalRTime: React.FC = () => {      
    // Sets the time from the server
    const [time, setTime] = useState<string | null>(null);
 
    useEffect(() => {
      hubConnection.on("setTime", message => {
        setTime(message);
      });     
    });
 
    return <p>The time is {time}</p>;
  };
 
  const SignalRClient: React.FC = () => {
    // Sets a client message, sent from the server
    const [clientMessage, setClientMessage] = useState<string | null>(null);
 
    useEffect(() => {
      hubConnection.on("setClientMessage", message => {
        setClientMessage(message);
      });
    });
 
    return <p>{clientMessage}</p>
  };
 
  return <><SignalRTime /><SignalRClient /></>;
}

export default App;
