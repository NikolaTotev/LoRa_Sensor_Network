// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiModel_SensorReadingEntry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiModel_SensorReadingEntry _$ApiModel_SensorReadingEntryFromJson(
        Map<String, dynamic> json) =>
    ApiModel_SensorReadingEntry(
      json['readingID'] as String,
      json['originID'] as String,
      DateTime.parse(json['timeOfCapture'] as String),
      json['payload'] as String,
    );

Map<String, dynamic> _$ApiModel_SensorReadingEntryToJson(
        ApiModel_SensorReadingEntry instance) =>
    <String, dynamic>{
      'readingID': instance.readingID,
      'originID': instance.originID,
      'timeOfCapture': instance.timeOfCapture.toIso8601String(),
      'payload': instance.payload,
    };
