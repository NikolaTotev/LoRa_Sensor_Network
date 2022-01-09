import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicLatestSensorReadings.dart';

class ApiLogic_SensorData{

	Future<ApiModel_BasicLatestSensorReadings> fetchLatestBasicSensorData() async {
		final response = await http
				.get(Uri.parse('https://nikolatotev-001-site1.ctempurl.com/api/SensorReadings'));

		if (response.statusCode == 200) {
			// If the server did return a 200 OK response,
			// then parse the JSON.
			return ApiModel_BasicLatestSensorReadings.fromJson(jsonDecode(response.body));
		} else {
			// If the server did not return a 200 OK response,
			// then throw an exception.
			throw Exception('Failed to load basic sensor readings.');
		}
	}
}