import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicLatestSensorReadings.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_SensorReadingEntry.dart';

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

	Future<List<ApiModel_SensorReadingEntry>> fetchWindowOfEntries(DateTime startDate, DateTime endDate, String stationID) async {
		Map<String, String> queryParams = {
			'startDate': startDate.toString(),
			'endDate': endDate.toString(),
			'stationID': stationID
		};
		String queryString = Uri(queryParameters: queryParams).query;

		final response = await http
				.get(Uri.parse('https://nikolatotev-001-site1.ctempurl.com/api/StationSensorReadingsWindowed?${queryString}'));

		if (response.statusCode == 200) {
			// If the server did return a 200 OK response,
			// then parse the JSON.
			List<dynamic> decodedList = jsonDecode(response.body);
			List<ApiModel_SensorReadingEntry> result = [];
			debugPrint("Body: ${response.body}");
			for(dynamic item in decodedList){
				ApiModel_SensorReadingEntry model = ApiModel_SensorReadingEntry.fromJson(item);// item as ApiModel_SensorReadingEntry;
				result.add(model);
			}

			return result;

		} else {
			// If the server did not return a 200 OK response,
			// then throw an exception.
			throw Exception('Failed to load basic sensor readings.');
		}
	}
}