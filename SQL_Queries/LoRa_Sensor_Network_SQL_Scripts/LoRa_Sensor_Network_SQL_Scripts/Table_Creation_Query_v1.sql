create table stations(
stationID varchar(255) PRIMARY KEY,
joinEUI varchar(255) NOT NULL,
devAddr varchar(128) NOT NULL,
stationName varchar(255) NOT NULL,
longitude decimal NOT NULL,
latitude decimal NOT NULL, 
numberOfMessages int NOT NULL,
lastSeen date NOT NULL,
supportedMeasurements text NOT NULL,
dateCreated varchar(128) NOT NULL,
);

--alter table stations
--drop column lastSeen

--alter table stations
--add lastSeen date NOT NULL

alter table sensordata
add lineNum int NOT NULL IDENTITY(1,1);

create table sensordata(
readingID varchar(255) PRIMARY KEY,
originID varchar(255) FOREIGN KEY REFERENCES stations(stationID),
timeOfCapture date NOT NULL,
payload text NOT NULL,
);

alter table signalData 
add tenantID varchar(128) NOT NULL

create table signalData(
entryID varchar(255) PRIMARY KEY,
relatedSensorData varchar(255) FOREIGN KEY REFERENCES sensordata(readingID),
sessionKeyID varchar(255) NOT NULL,
rssi int NOT NULL,
snr int NOT NULL,
spreadingFactor int NOT NULL,
confirmed bit NOT NULL,
bandID varchar(128)  NOT NULL,
clusterID varchar(128)  NOT NULL,
tenantID varchar(128)  NOT NULL,
consumedAirtime varchar(128)  NOT NULL,
gateway varchar(128)  NOT NULL
);

create table users(
userID varchar(255) PRIMARY KEY,
username varchar(255) NOT NULL,
email varchar(255) NOT NULL,
passwordHash varchar(255) NOT NULL,
lastSeen varchar(128)  NOT NULL,
);



