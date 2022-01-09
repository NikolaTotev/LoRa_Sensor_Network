// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiModel_BasicStationInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiModel_BasicStationInfo _$ApiModel_BasicStationInfoFromJson(
        Map<String, dynamic> json) =>
    ApiModel_BasicStationInfo(
      json['stationID'] as String,
      json['stationName'] as String,
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      DateTime.parse(json['lastSeen'] as String),
    );

Map<String, dynamic> _$ApiModel_BasicStationInfoToJson(
        ApiModel_BasicStationInfo instance) =>
    <String, dynamic>{
      'stationID': instance.stationID,
      'stationName': instance.stationName,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'lastSeen': instance.lastSeen.toIso8601String(),
    };
