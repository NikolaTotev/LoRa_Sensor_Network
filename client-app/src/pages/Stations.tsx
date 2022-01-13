import { Typography } from "@mui/material";
import React from "react";
import Loading from "../components/Loading";
import useAsync from "../hooks/useAsync";
import stationService from "../services/StationService";

export default function Stations() {
  const { data: stationList, loading, error } = useAsync(() => stationService.getStationList(), []);

  function getSupportedMeasurements(measurements: string): string[] {
    const result: any = JSON.parse(measurements);
    return result;
  }

  return (<>
    <Typography>Stations</Typography>
    <Loading loading={loading} error={error} >
      {() => stationList?.map(station => (<React.Fragment key={station.stationID}>
        <Typography>
          {station.stationName}
        </Typography>
        {getSupportedMeasurements(station.supportedMeasurements).map((reading) =>
          <Typography key={reading}>
            {reading}
          </Typography>
        )}
      </React.Fragment>))}
    </Loading>
  </>);
}
