import { Typography } from "@mui/material";
import React, { useEffect, useState } from "react";
import useSocket from "../contexts/ServerSocket";

export default function Home() {
  const { socket: hubConnection } = useSocket();

  const SignalRTime: React.FC = () => {     
    // Sets the time from the server
    const [time, setTime] = useState<string | null>(null);

    useEffect(() => {
      hubConnection.on("SetTime", message => {
        setTime(message);
      });     
    });
 
    return <Typography>The time is {time}</Typography>;
  };
 
  const SignalRClient: React.FC = () => {
    // Sets a client message, sent from the server
    const [clientMessage, setClientMessage] = useState<string | null>(null);
 
    useEffect(() => {
      hubConnection.on("SetClientMessage", message => {
        setClientMessage(message);
      });
    });
 
    return <Typography>{clientMessage}</Typography>
  };
 
  return (<>
    <SignalRTime /><SignalRClient />
  </>);
}
