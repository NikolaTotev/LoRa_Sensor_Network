import React, { createContext, ReactNode, useContext, useEffect, useState } from "react";
import * as signalR from "@microsoft/signalr";
import env from "react-dotenv";

interface ServerSocketProps {
  socket: signalR.HubConnection;
  loading: boolean;
}

const ServerSocketContext = createContext<ServerSocketProps>(null as any);

interface ServerSocketProviderProps {
  children: ReactNode;
}

export function ServerSocketProvider({children}: ServerSocketProviderProps) {
  const ENDPOINT = `${env.API_URL}/socket`;
  const [ loading, setLoading ] = useState(true);

  const hubConnection = new signalR.HubConnectionBuilder()
    .withUrl(ENDPOINT, {
      skipNegotiation: true,
      transport: signalR.HttpTransportType.WebSockets
    })
    .configureLogging(signalR.LogLevel.Information)
    .withAutomaticReconnect()
    .build();

  useEffect(() => {
    console.log(hubConnection.state)
    if (hubConnection.state !== 'Connected') {
      hubConnection.start().then(a => {
        setLoading(false);
      });
    }
  })

  return (
    <ServerSocketContext.Provider value={{socket: hubConnection, loading}}>
      { children }
    </ServerSocketContext.Provider>
  )
}

export default function useSocket() {
  return useContext(ServerSocketContext);
}
