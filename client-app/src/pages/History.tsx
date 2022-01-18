import { TextField, Typography, MenuItem, Select, Box, SelectChangeEvent, OutlinedInput, InputLabel, FormControl, Button, Container, Stack } from "@mui/material";
import React, { useEffect, useState } from "react";
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import LocalizationProvider from '@mui/lab/LocalizationProvider';
import DatePicker from '@mui/lab/DatePicker';
import useAsync from "../hooks/useAsync";
import stationService from "../services/StationService";
import Loading from "../components/Loading";
import Chip from '@mui/material/Chip';
import { Theme, useTheme } from '@mui/material/styles';
import Charts from "../components/Charts";

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
  const [generatedChart, setGeneratedChart] = useState(false);
  const theme = useTheme();

  function getSupportedMeasurements(measurements: string): string[] {
    const result: any = JSON.parse(measurements);
    return result;
  }

  const handleChange = (event: SelectChangeEvent<typeof selectedMeasurements>) => {
    const {
      target: { value },
    } = event;
    setGeneratedChart(false);
    setSelectedMeasurements(
      // On autofill we get a stringified value.
      typeof value === 'string' ? value.split(',') : value,
    );
  };

  const handleClick = () => {
    if (endDate && startDate && stationList && stationList.length > 0 && selectedMeasurements.length > 0) {
      setGeneratedChart(true);
    }
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

  return (<Container maxWidth="lg">
     <Typography variant="h3" gutterBottom component="div" align="center" sx={{color: '#0d47a1', marginTop: 2}}>
       History
      </Typography>
     <Loading loading={loading} error={error}>
        {() => (<Stack direction="row" spacing={2} sx={{marginTop: 3, border: '1 solid gray.500', borderRadius: '15px', boxShadow: 'rgba(0, 0, 0, 0.24) 0px 3px 8px', padding: 3}}>
          <Stack direction="column" spacing={3} sx={{marginTop: 2}}>
            <LocalizationProvider dateAdapter={AdapterDateFns}>
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
            <FormControl sx={{width: 300 }}>
              <InputLabel id="multiple-chip-label">Type</InputLabel>
              <Select
                labelId="multiple-chip-label"
                id="multiple-chip"
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
        <Button variant="outlined" onClick={handleClick} disabled={generatedChart}>Generate Chart</Button>
          </Stack>
        {generatedChart && <Box sx={{flexGrow: 1}}><Charts startDate={startDate!} endDate={endDate!} typesOfMeasurement={selectedMeasurements} stations={stationList!}/></Box>}
        </Stack>)}
     </Loading>
   </Container>);
}
