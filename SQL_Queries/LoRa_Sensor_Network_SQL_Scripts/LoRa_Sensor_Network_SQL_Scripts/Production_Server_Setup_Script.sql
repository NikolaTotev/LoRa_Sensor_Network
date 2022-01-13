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
 @StartDate date,
 @EndDate date,
 @StationID varchar(255)
as
begin
	select * from sensordata where originID = @StationID AND  CAST(timeOfCapture as date) >= @StartDate AND CAST(timeOfCapture as date) <= @EndDate order by lineNum desc
end

exec dbo.spSensorData_GetEntriesSensorReadingsByStationIDWindowed '2022-01-10', '2022-01-10', 'eui-a8610a3032306f09'
select * from sensordata

alter procedure dbo.spSensorData_GetEntriesSensorReadingsWindowed
 @StartDate datetime,
 @EndDate datetime
as
begin
	select * from sensordata where timeOfCapture >= @StartDate AND timeOfCapture <= @EndDate
end

alter procedure dbo.spSensorData_GetEntryLatestSensorReadingByStationID
 @StationID varchar(255)
as
begin
	select top 1 * from sensordata where originID = @StationID  order by lineNum desc; 
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

select * from sensordata order by lineNum

delete from sensordata where readingID = 'e1e6f3f4-169f-4069-ae68-1c587a1c5135'
delete from signalData where relatedSensorData = 'e1e6f3f4-169f-4069-ae68-1c587a1c5135'

delete from sensordata where readingID = 'eaf9500d-77da-4198-bee4-0a5fd83f12c7'
delete from signalData where relatedSensorData = 'eaf9500d-77da-4198-bee4-0a5fd83f12c7'


delete from sensordata where readingID = 'e1d2e57e-cdda-4c38-b7ae-9d19c594beeb'
delete from signalData where relatedSensorData = 'e1d2e57e-cdda-4c38-b7ae-9d19c594beeb'


delete from sensordata where readingID = '99af3c26-b751-4646-a16f-c8b7a11a875a'
delete from signalData where relatedSensorData = '99af3c26-b751-4646-a16f-c8b7a11a875a'


delete from sensordata where readingID = 'e1af6d2c-f16a-477b-bcfc-a1bd9b8528ea'
delete from signalData where relatedSensorData = 'e1af6d2c-f16a-477b-bcfc-a1bd9b8528ea'
eaf9500d-77da-4198-bee4-0a5fd83f12c7	eui-a8610a3032306f09	2022-01-11 11:50:30.970
e1d2e57e-cdda-4c38-b7ae-9d19c594beeb	eui-a8610a3032306f09	2022-01-11 11:52:34.443
99af3c26-b751-4646-a16f-c8b7a11a875a	eui-a8610a3032306f09	2022-01-11 11:54:38.870
e1af6d2c-f16a-477b-bcfc-a1bd9b8528ea	eui-a8610a3032306f09	2022-01-11 11:56:43.473
select*from stations

delete from sensordata where originID = 'eui-a8610a3032306f09'
delete from sensordata where originID = 'eui-a8610a3032306f09'
select * from sensordata order by lineNum
;with tmp as (
select *,
table_seq = row_number() over (order by id),
nice_seq = row_number() over (order by timeOfCapture, id)
from sensordata
)
update t1
set timeOfCapture = t2.timeOfCapture
   ,readingID = t2.readingID,
   originID = t2.originID,
   payload = t2.payload
   -- and any other columns in the table
from tmp t1
inner join tmp t2 on t1.table_seq=t2.nice_seq