import { TextField, Typography, MenuItem, Select, Box, SelectChangeEvent, OutlinedInput, InputLabel, FormControl, Button } from "@mui/material";
import React, { useEffect, useState } from "react";
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import LocalizationProvider from '@mui/lab/LocalizationProvider';
import DatePicker from '@mui/lab/DatePicker';
import useAsync from "../hooks/useAsync";
import stationService from "../services/StationService";
import Loading from "../components/Loading";
import Chip from '@mui/material/Chip';
import { Theme, useTheme } from '@mui/material/styles';
import Demo from "../components/Charts";

const ITEM_HEIGHT = 48;
const ITEM_PADDING_TOP = 8;
const MenuProps = {
  PaperProps: {
    style: {
      maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
      width: 250,
    },
  },
};

function onlyUnique(value: any, index: any, self: any) {
  return self.indexOf(value) === index;
}

function getStyles(name: string, measurement: readonly string[], theme: Theme) {
  return {
    fontWeight:
      measurement.indexOf(name) === -1
        ? theme.typography.fontWeightRegular
        : theme.typography.fontWeightMedium,
  };
}

export default function History() {
  const [startDate, setStartDate] = useState<Date | null>(new Date());
  const [endDate, setEndDate] = useState<Date | null>(new Date());
  const { data: stationList, loading, error } = useAsync(() => stationService.getStationList(), []);
  const [ allMeasurements, setAllMeasurements ] = useState<string[]>([]);
  const [selectedMeasurements, setSelectedMeasurements] = useState<string[]>([]);
  const theme = useTheme();

  function getSupportedMeasurements(measurements: string): string[] {
    const result: any = JSON.parse(measurements);
    return result;
  }

  const handleChange = (event: SelectChangeEvent<typeof selectedMeasurements>) => {
    const {
      target: { value },
    } = event;
    setSelectedMeasurements(
      // On autofill we get a stringified value.
      typeof value === 'string' ? value.split(',') : value,
    );
  };

  useEffect(() => {
    if (!stationList || !stationList.length) {
      return;
    }

    let measurements = stationList
      .map((station) => getSupportedMeasurements(station.supportedMeasurements))
      .flat(1)
      .filter(onlyUnique);
    
    setAllMeasurements(measurements);
  }, [stationList]);

  return (<>
     <Typography>History</Typography>
     <LocalizationProvider dateAdapter={AdapterDateFns}>
      <DatePicker
        label="Start Date"
        value={startDate}
        onChange={(newValue) => {
          setStartDate(newValue);
        }}
        maxDate={endDate}
        renderInput={(params) => <TextField {...params} />}
      />
      <DatePicker
        label="End Date"
        value={endDate}
        onChange={(newValue) => {
          setEndDate(newValue);
        }}
        maxDate={new Date()}
        minDate={startDate}
        renderInput={(params) => <TextField {...params} />}
      />
     </LocalizationProvider>
     <Loading loading={loading} error={error}>
        {() => (<><FormControl sx={{width: 300 }}>
          <InputLabel id="demo-multiple-chip-label">Type</InputLabel>
          <Select
          labelId="demo-multiple-chip-label"
          id="demo-multiple-chip"
          multiple
          value={selectedMeasurements}
          onChange={handleChange}
          input={<OutlinedInput id="select-multiple-chip" label="Chip" />}
          renderValue={(selectedMeasurements) => (
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
              {selectedMeasurements.map((value) => (
                <Chip key={value} label={value} />
              ))}
            </Box>
          )}
          MenuProps={MenuProps}
        >
          {allMeasurements.map((measurement) => (
            <MenuItem
              key={measurement}
              value={measurement}
              style={getStyles(measurement, selectedMeasurements, theme)}
            >
              {measurement}
            </MenuItem>
          ))}
        </Select>
        
        </FormControl>
        {startDate && endDate && stationList && selectedMeasurements.length > 0 && <Demo startDate={startDate} endDate={endDate} typesOfMeasurement={selectedMeasurements} stations={stationList}/>}
        </>)}
     </Loading>
     
   </>);
}
