import { Box, Typography, List, ListItemButton, ListItemText, TextField, MenuItem } from "@mui/material";
import React, { useEffect, useState } from "react";
import Loading from "../components/Loading";
import useSocket from "../contexts/ServerSocket";
import useAsync from "../hooks/useAsync";
import stationService from "../services/StationService";

export default function Stations() {
  const { data: stationList, loading, error } = useAsync(() => stationService.getStationList(), []);
  const [selectedIndex, setSelectedIndex] = useState(-1);
  const [selectedMeasurment, setSelectedMeasurement] = useState("");
  const { socket: hubConnection } = useSocket();
  const [ liveData, setLiveData ] = useState("");
  
  function getSupportedMeasurements(measurements: string): string[] {
    const result: any = JSON.parse(measurements);
    return result;
  }

  useEffect(() => {
    hubConnection.on("SetLatestReading", message => {
      if (hubConnection.state === 'Connected' 
        && selectedIndex !== -1 
        && stationList
        && stationList[selectedIndex] 
        && selectedMeasurment !== "") {
          console.log(stationList);
          const result: any = JSON.parse(message.payload);
          setLiveData(result[selectedMeasurment]);
      }
    });
  });

  useEffect(() => {
    if (hubConnection.state === 'Connected' 
    && selectedIndex !== -1 
    && stationList 
    && stationList[selectedIndex] 
    && selectedMeasurment !== "") {
      hubConnection.invoke("SendLatestReading", stationList[selectedIndex].stationID);
    }
  });

  const handleListItemClick = (
    event: React.MouseEvent<HTMLDivElement, MouseEvent>,
    index: number,
  ) => {
    setSelectedIndex(index);
  };

  const handleSelectMeasurment = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSelectedMeasurement(event.target.value);
  };

  return (<Box sx={{ width: '100%', maxWidth: 360, bgcolor: 'background.paper' }}>
    <Typography>Stations</Typography>
    <Loading loading={loading} error={error} >
    {() => (
        <List component="nav">
          {stationList?.map((station, index) => (
            <ListItemButton
              selected={selectedIndex === index}
              onClick={(event) => handleListItemClick(event, index)}
              key={station.stationID}
            >
              <ListItemText primary={station.stationName} />
            </ListItemButton>))}
        </List>

        )}
    </Loading>
    {selectedIndex !== -1 && stationList && <>
      <TextField
          id="measurement"
          select
          label="Select"
          value={selectedMeasurment}
          onChange={handleSelectMeasurment}
          helperText="Please select type of measurement"
        >
          {getSupportedMeasurements(stationList[selectedIndex]!.supportedMeasurements).map((option) => (
            <MenuItem key={option} value={option}>
              {option}
            </MenuItem>
          ))}
        </TextField>
    </>}
    {selectedIndex !== -1 && stationList && stationList[selectedIndex] && selectedMeasurment !== "" && <>
    <Typography>
      Live data
    </Typography>
    <Typography>
      {liveData}
    </Typography>
    </>}
  </Box>);
}
