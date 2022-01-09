import 'package:json_annotation/json_annotation.dart';
part 'ApiModel_BasicStationInfo.g.dart';

@JsonSerializable()
class ApiModel_BasicStationInfo {
  String stationID;
  String stationName;
  double longitude;
  double latitude;
  DateTime lastSeen;

  ApiModel_BasicStationInfo(this.stationID, this.stationName, this.longitude, this.latitude, this.lastSeen);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ApiModel_BasicStationInfo.fromJson(Map<String, dynamic> json) => _$ApiModel_BasicStationInfoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ApiModel_BasicStationInfoToJson(this);
}
