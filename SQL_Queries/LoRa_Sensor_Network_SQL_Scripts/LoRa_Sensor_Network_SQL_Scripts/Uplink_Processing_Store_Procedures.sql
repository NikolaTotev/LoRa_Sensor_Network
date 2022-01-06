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
	@tennantID varchar(128),
	@consumedAirtime varchar(128),
	@gateway varchar(128)  
as
begin
	insert into signalData 
	(entryID, relatedSensorData, sessionKeyID,rssi, snr,spreadingFactor,confirmed,bandID,clusterID,tennantID, consumedAirtime, gateway) 
	values 
	(@entryID,@relatedSensorData,@sessionKeyID,@rssi,@snr,@spreadingFactor,@confirmed,@bandID,@clusterID,@tennantID,@consumedAirtime,@gateway);
end


create procedure dbo.spStations_UpdateFieldStationLastSeen
 @lastSeen date
as
begin
	update stations 
	set lastSeen = @lastSeen
end