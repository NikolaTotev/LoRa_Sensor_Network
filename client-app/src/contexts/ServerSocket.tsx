import React, { createContext, ReactNode, useContext } from "react";
import * as signalR from "@microsoft/signalr";
import env from "react-dotenv";

interface ServerSocketProps {
  socket: signalR.HubConnection;
}

const ServerSocketContext = createContext<ServerSocketProps>(null as any);

interface ServerSocketProviderProps {
  children: ReactNode;
}

export function ServerSocketProvider({children}: ServerSocketProviderProps) {
  const ENDPOINT = `${env.API_URL}/initTry`;

  const hubConnection = new signalR.HubConnectionBuilder()
    .withUrl(ENDPOINT, {
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
      hubConnection.invoke("SendConnectionId", hubConnection.connectionId);
    }
  });

  return (
    <ServerSocketContext.Provider value={{socket: hubConnection}}>
      { children }
    </ServerSocketContext.Provider>
  )
}

export default function useSocket() {
  return useContext(ServerSocketContext);
}
