import React, { useEffect, useState } from 'react';
import Paper from '@mui/material/Paper';
import {
  ArgumentAxis,
  ValueAxis,
  Chart,
  LineSeries,
  Legend,
} from '@devexpress/dx-react-chart-material-ui';
import { ArgumentScale, ValueScale } from '@devexpress/dx-react-chart';
import { scaleLinear, scaleTime } from 'd3-scale';
import stationService, { Reading, Station } from '../services/StationService';
import useAsync from '../hooks/useAsync';
import Loading from './Loading';

interface ChartsProps {
  stations: Station[];
  typesOfMeasurement: string[];
  startDate: Date;
  endDate: Date;
}

interface StationReading {
  station: Station;
  readings: Reading[];
  neededMeasurements: string[];
}

export default function Charts({ stations, typesOfMeasurement, startDate, endDate }: ChartsProps) {
  const { data: stationReadings, loading, error } = useAsync<StationReading[]>(async () => {
    let stationReads = await Promise.all(stations.map(async (station) => {
      const neededMeasurements = getSupportedMeasurements(station.supportedMeasurements).filter((measurement: any) => typesOfMeasurement.includes(measurement));
      const readings = await stationService.getSensorReadingsWindowed(startDate.toISOString(), endDate.toISOString(), station.stationID);
      return {
        station,
        readings,
        neededMeasurements
      }
    }));

    return stationReads;
  }, [stations, typesOfMeasurement, startDate, endDate]);

  function getSupportedMeasurements(measurements: string): any {
    const result: any = JSON.parse(measurements);
    return result;
  }

  const [chartData, setChartData] = useState<any[]>([]);
  
  useEffect(() => {
    if (stationReadings) {
      const data: any[] = [];
      stationReadings.forEach((stationReading) => {
        stationReading.readings.forEach((reading) => {
          const payload = getSupportedMeasurements(reading.payload);
          const neededResult: {[key: string]: any} = {};
          stationReading.neededMeasurements.forEach((measurement) => {
            neededResult[`${stationReading.station.stationID}-${measurement}`] = Number(payload[measurement]);
          })
          neededResult["timeOfCapture"] = new Date(reading["timeOfCapture"]);
          data.push(neededResult);
        })
      });

      setChartData(data);
    }
  }, [stationReadings]);

  return (
    <Loading loading={loading} error={error}>
      {() => (chartData.length > 0 && <>
    <Paper>
      <Chart
        data={chartData}
      >
        {typesOfMeasurement.map((type) => <ValueScale factory={scaleLinear} name={type} key={`scale-${type}`} />)}
        <ArgumentScale factory={scaleTime} />
        <ArgumentAxis />
        {typesOfMeasurement.map((type) => <ValueAxis scaleName={type} showGrid={false} showLine={true} key={`axis-${type}`}/>)}

        {stationReadings && stationReadings.map((stationReading) => (
          stationReading.neededMeasurements.map((measurement) => (
            <LineSeries
              name={`${stationReading.station.stationName}  ${measurement}`}
              valueField={`${stationReading.station.stationID}-${measurement}`}
              scaleName={measurement}
              argumentField='timeOfCapture'
              key={`${stationReading.station.stationName}  ${measurement}`}
            />
          )))).flat(1)}

        <Legend position="bottom" />
      </Chart>
    </Paper>
      </>)}
    </Loading>
  );
}
