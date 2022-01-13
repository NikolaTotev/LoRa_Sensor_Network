import { Typography } from "@mui/material";
import React, { useEffect, useState } from "react";
import Loading from "../components/Loading";
import useSocket from "../contexts/ServerSocket";
import useAsync from "../hooks/useAsync";
import stationService from "../services/StationService";

export default function Home() {
  const { socket: hubConnection } = useSocket();

  const SignalRTime: React.FC = () => {
    const [time, setTime] = useState<string | null>(null);

    useEffect(() => {
      hubConnection.on("SetTime", message => {
        setTime(message);
      });
    });
 
    return <Typography>The time is {time}</Typography>;
  };
 
  const SignalRClient: React.FC = () => {
    const [clientMessage, setClientMessage] = useState<string | null>(null);
 
    useEffect(() => {
      hubConnection.on("SetClientMessage", message => {
        setClientMessage(message);
      });
    });
 
    return <Typography>{clientMessage}</Typography>
  };
 
  const { data: sensorReadings, loading, error } = useAsync(() => stationService.getStationReadings(), []);

  return (<>
    <SignalRTime /><SignalRClient />
    <Loading loading={loading} error={error}>
      {() => (<>
        <Typography>
          {sensorReadings?.averageHumidity}
        </Typography>
        <Typography>
          {sensorReadings?.averageTemperature}
        </Typography>
        <Typography>
          {sensorReadings?.lastUpdate}
        </Typography>
        </>)}
    </Loading>
  </>);
}
