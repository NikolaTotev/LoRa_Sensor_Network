// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiModel_BasicLatestSensorReadings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiModel_BasicLatestSensorReadings _$ApiModel_BasicLatestSensorReadingsFromJson(
        Map<String, dynamic> json) =>
    ApiModel_BasicLatestSensorReadings(
      (json['averageTemperature'] as num).toDouble(),
      (json['averageHumidity'] as num).toDouble(),
      json['lastUpdate'] as String,
    );

Map<String, dynamic> _$ApiModel_BasicLatestSensorReadingsToJson(
        ApiModel_BasicLatestSensorReadings instance) =>
    <String, dynamic>{
      'averageTemperature': instance.averageTemperature,
      'averageHumidity': instance.averageHumidity,
      'lastUpdate': instance.lastUpdate,
    };
