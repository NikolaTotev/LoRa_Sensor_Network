import 'package:json_annotation/json_annotation.dart';
part 'ApiModel_BasicLatestSensorReadings.g.dart';

@JsonSerializable()
class ApiModel_BasicLatestSensorReadings{
	late double averageTemperature;

	ApiModel_BasicLatestSensorReadings(this.averageTemperature);

	/// A necessary factory constructor for creating a new User instance
	/// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
	/// The constructor is named after the source class, in this case, User.
	factory ApiModel_BasicLatestSensorReadings.fromJson(Map<String, dynamic> json) => _$ApiModel_BasicLatestSensorReadingsFromJson(json);

	/// `toJson` is the convention for a class to declare support for serialization
	/// to JSON. The implementation simply calls the private, generated
	/// helper method `_$UserToJson`.
	Map<String, dynamic> toJson() => _$ApiModel_BasicLatestSensorReadingsToJson(this);
}