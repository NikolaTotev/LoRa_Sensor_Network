import { Container, Typography } from "@mui/material";
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
      {() => (<Container maxWidth="md" sx={{display: 'flex', alignItems: 'center', flexFlow: 'column', marginTop: 3}}>
        <Typography variant="h2" gutterBottom component="div" sx={{color: '#0d47a1'}}>
          Sofia
        </Typography>
        <Typography variant="h5" gutterBottom component="div" align="center" sx={{color: '#0d47a1'}}>
          Last update:
        </Typography>
        <Typography variant="h5" gutterBottom component="div" align="center" sx={{color: '#0d47a1'}}>
          {averageData.lastUpdate}
        </Typography>
        <Typography variant="h5" gutterBottom component="div" align="center" sx={{color: '#0d47a1'}}>
          Avg. Temperature
        </Typography>
        <Typography variant="h3" gutterBottom component="div" align="center" sx={{fontWeight: 'bold', color: '#0d47a1'}}>
          {averageData.averageTemperature} °C
        </Typography>
        <Typography variant="h5" gutterBottom component="div" align="center" sx={{color: '#0d47a1'}}>
          Avg. Humidity
        </Typography>
        <Typography variant="h3" gutterBottom component="div" align="center" sx={{fontWeight: 'bold', color: '#0d47a1'}}>
          {averageData.averageHumidity} %
        </Typography>
        </Container>)}
    </Loading>
  </>);
}
