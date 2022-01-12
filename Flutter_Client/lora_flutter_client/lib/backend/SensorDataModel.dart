import 'package:flutter/foundation.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicLatestSensorReadings.dart';
import 'package:lora_flutter_client/backend/ApiLogic_SensorData.dart';
import 'package:lora_flutter_client/ProjectDataModels/ChartModel_TimeSeries.dart';
import '../ProjectDataModels/ApiModel_SensorReadingEntry.dart';
import 'dart:convert';

class SensorDataModel extends ChangeNotifier {
	ApiLogic_SensorData _logic_sensorData = ApiLogic_SensorData();

	bool loaded = false;
	late ApiModel_BasicLatestSensorReadings latestData;

	Future<ApiModel_BasicLatestSensorReadings> getNewData() {
		debugPrint("getting new data");
		return _logic_sensorData.fetchLatestBasicSensorData();
	}

	Future<void> updateData () async {
		loaded = false;
		notifyListeners();
		Future<ApiModel_BasicLatestSensorReadings> rawFutureData = getNewData();
		latestData = await rawFutureData;
		loaded = true;
		notifyListeners();
	}

	void refresh() {
		updateData();
	}
}
