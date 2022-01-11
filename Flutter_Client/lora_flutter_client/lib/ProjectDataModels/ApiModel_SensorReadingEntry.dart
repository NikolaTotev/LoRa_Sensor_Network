import 'package:json_annotation/json_annotation.dart';

part 'ApiModel_SensorReadingEntry.g.dart';

@JsonSerializable()
class ApiModel_SensorReadingEntry {
  String readingID;
  String originID;
  DateTime timeOfCapture;
  String payload;

  ApiModel_SensorReadingEntry(this.readingID, this.originID,this.timeOfCapture,this.payload);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ApiModel_SensorReadingEntry.fromJson(Map<String, dynamic> json) =>
      _$ApiModel_SensorReadingEntryFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ApiModel_SensorReadingEntryToJson(this);
}
