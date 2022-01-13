import { Typography } from "@mui/material";
import React from "react";
import Loading from "../components/Loading";
import useAsync from "../hooks/useAsync";
import stationService from "../services/StationService";

export default function Stations() {
  const { data: stationList, loading, error } = useAsync(() => stationService.getStationList(), []);

  return (<>
    <Typography>Stations</Typography>
    <Loading loading={loading} error={error} >
      {() => stationList?.map(station => (<>
        <Typography>
          {station.stationName}
        </Typography>
      </>))}
    </Loading>
  </>);
}
