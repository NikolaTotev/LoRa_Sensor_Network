import { Box, Typography, List, ListItemButton, ListItemText, TextField, MenuItem, Button, Container, Stack } from "@mui/material";
import React, { useEffect, useState } from "react";
import Loading from "../components/Loading";
import useSocket from "../contexts/ServerSocket";
import useAsync from "../hooks/useAsync";
import stationService, { Station } from "../services/StationService";
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import LocalizationProvider from '@mui/lab/LocalizationProvider';
import DatePicker from '@mui/lab/DatePicker';
import Charts from "../components/Charts";

export default function Stations() {
  const { data: stationList, loading, error } = useAsync(() => stationService.getStationList(), []);
  const [selectedIndex, setSelectedIndex] = useState(-1);
  const [selectedMeasurment, setSelectedMeasurement] = useState("");
  const { socket: hubConnection } = useSocket();
  const [ liveData, setLiveData ] = useState("");
  const [startDate, setStartDate] = useState<Date | null>(new Date());
  const [endDate, setEndDate] = useState<Date | null>(new Date());
  const [generatedChart, setGeneratedChart] = useState(false);
  const [selectedMeasurementArray, setSelectedMeasurementArray] = useState<string[]>([]);
  const [selectedStationArray, setSelectedStationArray] = useState<Station[]>([]); 
  
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
    setGeneratedChart(false);
    setLiveData('');
  };

  const handleClick = () => {
    if (endDate && startDate && stationList && stationList[selectedIndex] && selectedMeasurment !== '') {
      setGeneratedChart(true);
      setSelectedMeasurementArray([selectedMeasurment]);
      setSelectedStationArray([stationList[selectedIndex]]);
    }
  };

return (<Container maxWidth="lg">
<Typography variant="h3" gutterBottom component="div" align="center" sx={{color: '#0d47a1', marginTop: 2}}>
  Stations
 </Typography>
<Loading loading={loading} error={error}>
   {() => (stationList && <Stack direction="row" spacing={2} sx={{marginTop: 3, border: '1 solid gray.500', borderRadius: '15px', boxShadow: 'rgba(0, 0, 0, 0.24) 0px 3px 8px', padding: 3}}>
     <Stack direction="column" spacing={3} sx={{marginTop: 2}}>
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
       {stationList && selectedIndex!== -1 && <><LocalizationProvider dateAdapter={AdapterDateFns}>
         <DatePicker
           label="Start Date"
           value={startDate}
           onChange={(newValue) => {
             setGeneratedChart(false);
             setStartDate(newValue);
           }}
           maxDate={endDate}
           renderInput={(params) => <TextField {...params} />}
         />
         <DatePicker
           label="End Date"
           value={endDate}
           onChange={(newValue) => {
             setGeneratedChart(false);
             setEndDate(newValue);
           }}
           maxDate={new Date()}
           minDate={startDate}
           renderInput={(params) => <TextField {...params} />}
         />
       </LocalizationProvider>
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
   <Button variant="outlined" onClick={handleClick} disabled={generatedChart}>Generate Chart</Button>
            </>}
     </Stack>
     <Box sx={{flexGrow: 1, display: 'flex', flexDirection: 'column'}}>
     {selectedIndex !== -1 && stationList && stationList[selectedIndex] && selectedMeasurment !== "" && <>
    <Loading loading={liveData === ''} error={null}>
      {() => <>
        <Typography variant="h4" gutterBottom component="div" align="center" sx={{color: '#0d47a1'}}>
          Live data: {liveData}
        </Typography>
      </>}
    </Loading>
    </>}
    {generatedChart && <Box sx={{flexGrow: 1}}><Charts startDate={startDate!} endDate={endDate!} typesOfMeasurement={selectedMeasurementArray} stations={selectedStationArray}/></Box>}
     </Box>
   </Stack>)}
</Loading>
</Container>);
}
