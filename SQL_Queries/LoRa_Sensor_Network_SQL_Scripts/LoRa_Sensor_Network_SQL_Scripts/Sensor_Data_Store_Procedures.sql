
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
