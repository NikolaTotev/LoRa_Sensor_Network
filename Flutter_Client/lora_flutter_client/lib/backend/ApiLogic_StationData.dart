import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicStationInfo.dart';


class ApiLogic_StationData{

	Future<List<dynamic>> fetchStationList() async {
		final response = await http
				.get(Uri.parse('https://nikolatotev-001-site1.ctempurl.com/api/GetStationList'));

		if (response.statusCode == 200) {
			// If the server did return a 200 OK response,
			// then parse the JSON.
			return jsonDecode(response.body);
		} else {
			// If the server did not return a 200 OK response,
			// then throw an exception.
			throw Exception('Failed to load basic sensor readings.');
		}
	}
}