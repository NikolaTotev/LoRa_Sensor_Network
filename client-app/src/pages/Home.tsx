import { Typography } from "@mui/material";
import React, { useEffect, useState } from "react";
import Loading from "../components/Loading";
import useSocket from "../contexts/ServerSocket";

interface AverageData {
  averageTemperature: string;
  averageHumidity: string;
  lastUpdate: string;
}

export default function Home() {
  const { socket: hubConnection } = useSocket();
  
  const [ averageData, setAverageData ] = useState<AverageData>({
    averageTemperature: "",
    averageHumidity: "",
    lastUpdate: ""
  });

  useEffect(() => {
    hubConnection.on("SetAverageData", message => {
      setAverageData(message);
    });
  });

  useEffect(() => {
    if (hubConnection.state === 'Connected') {
      hubConnection.invoke("SendAverageData");
    }
  });

  return (<>
    <Loading loading={averageData.lastUpdate === ""} error={null}>
      {() => (<>
        <Typography>
          Sofia
          <br/>
          {averageData.lastUpdate}
        </Typography>
        <Typography>
          {averageData.averageTemperature} °C
        </Typography>
        <Typography>
          {averageData.averageHumidity} %
        </Typography>
        </>)}
    </Loading>
  </>);
}
