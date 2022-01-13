
create procedure dbo.spSensorData_GetEntriesSensorReadingsByStationIDWindowed
 @StartDate date,
 @EndDate date,
 @StationID varchar(255)
as
begin
	select * from sensordata where originID = @StationID AND  timeOfCapture >= @StartDate AND timeOfCapture <= @EndDate
end

create procedure dbo.spSensorData_GetEntriesSensorReadingsWindowed
 @StartDate date,
 @EndDate date
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

exec dbo.spSensorData_GetEntryLatestSensorReadingByStationID "eui-a8610a3032306f09"

insert into sensordata(readingID, originID, payload, timeOfCapture) 
values ('12a16cf-1c84-4772-8f15-2471b5741f8b', 'eui-a8610a3032306f09', '{"temperature": "42.42"}', '2022-02-09');


exec dbo.spSensorData_GetEntriesSensorReadingsByStationIDWindowed "2022-01-09", "2022-02-09", "eui-a8610a3032306f09"