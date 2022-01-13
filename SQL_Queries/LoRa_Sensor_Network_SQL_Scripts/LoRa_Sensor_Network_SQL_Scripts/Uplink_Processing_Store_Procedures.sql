create procedure dbo.spSensorData_AddEntrySensorReading
 @readingID varchar(255),
 @originID varchar(255),
 @payload text,
 @timeOfCapture date
as
begin
	insert into sensordata (readingID,originID,payload,timeOfCapture) 
	values (@readingID,@originID,@payload,@timeOfCapture);
end

create procedure dbo.spSignalData_AddEntrySignalData
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

create procedure dbo.spStations_AddEntryNewStation
	@stationID varchar(255),
	@joinEUI varchar(255),
	@devAddr varchar(128),
	@stationName varchar(255),
	@longitude decimal,
	@latitude decimal,
	@numberOfMessages int,
	@supportedMeasurements text,
	@dateCreated varchar(128),
	@lastSeen date
as
begin
	insert into stations 
	(stationID, joinEUI, devAddr, stationName, longitude, latitude, numberOfMessages, supportedMeasurements, dateCreated, lastSeen) 
	values 
	(@stationID, @joinEUI, @devAddr, @stationName, @longitude, @latitude, @numberOfMessages, @supportedMeasurements, @dateCreated, @lastSeen);
end



create procedure dbo.spStations_UpdateFieldStationLastSeen
 @lastSeen date,
 @StationID varchar(255)
as
begin
	update stations 
	set lastSeen = @lastSeen
	where stationID = @StationID
end