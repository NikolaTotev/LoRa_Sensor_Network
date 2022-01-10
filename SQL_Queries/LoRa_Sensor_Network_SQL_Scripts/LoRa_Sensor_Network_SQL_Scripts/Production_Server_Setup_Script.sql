select * from stations
select * from sensordata
select * from signalData

-- UPLINK STORE PROCEDURES ====================================================================
alter procedure dbo.spSensorData_AddEntrySensorReading
 @readingID varchar(255),
 @originID varchar(255),
 @payload text,
 @timeOfCapture datetime
as
begin
	insert into sensordata (readingID,originID,payload,timeOfCapture) 
	values (@readingID,@originID,@payload,@timeOfCapture);
end

alter  procedure dbo.spSignalData_AddEntrySignalData
	@entryID varchar(255),
	@relatedSensorData varchar(255),
	@sessionKeyID varchar(255),
	@rssi int,
	@snr int,
	@spreadingFactor int,
	@confirmed bit,
	@bandID varchar(128),
	@clusterID varchar(128),
	@tenantID varchar(128),
	@consumedAirtime varchar(128),
	@gateway varchar(128)  
as
begin
	insert into signalData 
	(entryID, relatedSensorData, sessionKeyID,rssi, snr,spreadingFactor,confirmed,bandID,clusterID,tenantID, consumedAirtime, gateway) 
	values 
	(@entryID,@relatedSensorData,@sessionKeyID,@rssi,@snr,@spreadingFactor,@confirmed,@bandID,@clusterID,@tenantID,@consumedAirtime,@gateway);
end

alter procedure dbo.spStations_AddEntryNewStation
	@stationID varchar(255),
	@joinEUI varchar(255),
	@devAddr varchar(128),
	@stationName varchar(255),
	@longitude decimal,
	@latitude decimal,
	@numberOfMessages int,
	@supportedMeasurements text,
	@dateCreated varchar(128),
	@lastSeen datetime
as
begin
	insert into stations 
	(stationID, joinEUI, devAddr, stationName, longitude, latitude, numberOfMessages, supportedMeasurements, dateCreated, lastSeen) 
	values 
	(@stationID, @joinEUI, @devAddr, @stationName, @longitude, @latitude, @numberOfMessages, @supportedMeasurements, @dateCreated, @lastSeen);
end

-- STATION DATA STORE PROCEDURES ==============================================================
create procedure dbo.spStations_GetEntriesListOfStations
as
begin
	select * from stations;
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

alter procedure dbo.spStations_UpdateFieldStationLastSeen
 @lastSeen datetime,
 @StationID varchar(255)
as
begin
	update stations 
	set lastSeen = @lastSeen
	where stationID = @StationID
end

exec dbo.spStations_GetEntriesListOfStationIDs


-- SENSOR DATA STORE PROCEDURES ================================================================
alter procedure dbo.spSensorData_GetEntriesSensorReadingsByStationIDWindowed
 @StartDate datetime,
 @EndDate datetime,
 @StationID varchar(255)
as
begin
	select * from sensordata where originID = @StationID AND  timeOfCapture >= @StartDate AND timeOfCapture <= @EndDate
end

alter procedure dbo.spSensorData_GetEntriesSensorReadingsWindowed
 @StartDate datetime,
 @EndDate datetime
as
begin
	select * from sensordata where timeOfCapture >= @StartDate AND timeOfCapture <= @EndDate
end

create procedure dbo.spSensorData_GetEntryLatestSensorReadingByStationID
 @StationID varchar(255)
as
begin
	select top 1 * from sensordata where originID = @StationID; 
end

-- DUMMY DATA INSERT QUERIES
insert into sensordata(readingID, originID, payload, timeOfCapture) 
values ('12a16cf-1c84-4772-8f15-247123b5741f8b', 'eui-a8610a3032306f09', '{"temperature": "123"}', '2022-01-09');

insert into sensordata(readingID, originID, payload, timeOfCapture) 
values ('12a16cf-1c84-4772-8f15-247133b5741f8b', 'eui-a8610a3032306f09', '{"temperature": "456"}', '2022-01-10');

insert into sensordata(readingID, originID, payload, timeOfCapture) 
values ('12a16cf-1c84-4772-8f15-2471b522741f8b', 'eui-a8610a3032306f09', '{"temperature": "789"}', '2022-01-11');

insert into stations (stationID, joinEUI, devAddr,stationName,longitude,latitude,numberOfMessages,lastSeen,supportedMeasurements,dateCreated)
values ('eui-a8610a3032306f09', 'joinEUI', 'devAddr', 'stationName', 12, 21, 0, '2022-01-09', 'supportedMessages', '2022-01-09');


exec dbo.spSensorData_GetEntryLatestSensorReadingByStationID "eui-a8610a3032306f09"

select * from sensordata

delete from sensordata where readingID = 'e1e6f3f4-169f-4069-ae68-1c587a1c5135'
delete from signalData where relatedSensorData = 'e1e6f3f4-169f-4069-ae68-1c587a1c5135'

delete from sensordata where readingID = '1623a111-3469-49ab-8292-302a183cb432'
delete from signalData where relatedSensorData = '1623a111-3469-49ab-8292-302a183cb432'

select*from stations

delete from sensordata where originID = 'eui-a8610a3032306f09'