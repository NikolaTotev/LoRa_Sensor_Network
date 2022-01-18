import React, { useEffect, useState } from 'react';
import Paper from '@mui/material/Paper';
import {
  ArgumentAxis,
  ValueAxis,
  BarSeries,
  Chart,
  LineSeries,
  Legend,
} from '@devexpress/dx-react-chart-material-ui';
import { ValueScale } from '@devexpress/dx-react-chart';
import stationService, { Reading, Station } from '../services/StationService';
import useAsync from '../hooks/useAsync';
import Loading from './Loading';

interface IDataItem {
  month: string,
  sale: number,
  total: number,
  smth: number;
}

const chartData1: IDataItem[] = [
  { month: 'Jan', sale: 50, total: 987, smth: 200 },
  { month: 'Feb', sale: 100, total: 3000, smth: 250 },
  { month: 'March', sale: 30, total: 1100, smth: 210 },
  { month: 'April', sale: 107, total: 7100, smth: 260 },
  { month: 'May', sale: 95, total: 4300, smth: 220 },
  { month: 'June', sale: 150, total: 7500, smth: 300 },
];

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
            neededResult[`${stationReading.station.stationID}-${measurement}`] = payload[measurement];
          })
          neededResult["timeOfCapture"] = new Date(reading["timeOfCapture"]);
          data.push(neededResult);
        })
      });

      console.log(data)
      setChartData(data);
    }
  }, [stationReadings])

  return (
    <Loading loading={loading} error={error}>
      {() => (chartData.length > 0 && <>
    <Paper>
      <Chart
        data={chartData}
      >
        {/* {typesOfMeasurement.map((type) => <ValueScale name={type} key={`scale-${type}`} />)} */}
        <ValueScale name="scale" />
        <ArgumentAxis />
        {/* {typesOfMeasurement.map((type) => <ValueAxis scaleName={type} showGrid={false} showLine={true} showTicks={true} key={`axis-${type}`}/>)} */}
        <ValueAxis scaleName="scale" position="right" showGrid={false} showLine={true} showTicks={true} />

        {stationReadings && stationReadings.map((stationReading) => (<React.Fragment key={stationReading.station.stationID}>
          {stationReading.neededMeasurements.map((measurement) => (
            <LineSeries
              name={`${stationReading.station.stationName}  ${measurement}`}
              valueField={`${stationReading.station.stationID}-${measurement}`}
              scaleName="scale"
              argumentField='timeOfCapture'
              key={`${stationReading.station.stationName}  ${measurement}`}
            />
          ))}
        </React.Fragment>))}
        <Legend position="bottom" />
      </Chart>
    </Paper>
      </>)}
    </Loading>
  );
}
