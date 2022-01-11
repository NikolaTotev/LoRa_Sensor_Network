create procedure dbo.spStations_GetEntriesListOfStations
as
begin
	select stationID, stationName, latitude, longitude, lastSeen from stations;
end

create procedure dbo.spStations_GetEntriesListOfStationIDs
as
begin
	select stationID from stations;
end

create procedure dbo.spStations_GetEntryAvailableMeasurementsByStationID
	@stationID varchar(255)
as
begin
	select supportedMeasurements from stations where stationID=@stationID;
end

create procedure dbo.spStations_GetEntryFullStationInfoByStationID
	@stationID varchar(255)
as
begin
	select * from stations where stationID=@stationID;
end