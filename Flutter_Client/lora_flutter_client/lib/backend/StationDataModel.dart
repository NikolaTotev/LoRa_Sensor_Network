// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicLatestSensorReadings.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicStationInfo.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_SensorReadingEntry.dart';
import 'package:lora_flutter_client/backend/ApiLogic_SensorData.dart';
import 'package:lora_flutter_client/backend/ApiLogic_StationData.dart';
import 'dart:convert';

import '../ProjectDataModels/ChartModel_TimeSeries.dart';

class StationDataModel extends ChangeNotifier {
  ApiLogic_StationData _logic_stationData = ApiLogic_StationData();
  ApiLogic_SensorData _logic_sensorData = ApiLogic_SensorData();

  late ApiModel_BasicStationInfo selectedStation;
  late ApiModel_SensorReadingEntry selectedStationLatestSensorEntry;
  Map<String, dynamic> selectedStationLatestData= {};
  List<ApiModel_BasicStationInfo> stationList = [];
  List<TimeSeries> chartData = [];
  List<ApiModel_SensorReadingEntry> listOfEntries = [];
  String selectedMeasurement= "Loading...";
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  Future<List<dynamic>> getStationList() {
    return _logic_stationData.fetchStationList();
  }

  Future<bool> LoadStationList() async {
    Future<List<dynamic>> rawDataFuture = getStationList();
    List<dynamic> rawData = await rawDataFuture;
    for (dynamic entry in rawData) {
      ApiModel_BasicStationInfo stationInfo = ApiModel_BasicStationInfo.fromJson(entry);
      stationList.add(stationInfo);
    }
    selectedStation = stationList[0];
    LoadLatestStationData();
    return true;
  }

  Future<bool> LoadLatestStationData()async{
    Future<ApiModel_SensorReadingEntry> rawDataFuture = _logic_sensorData.fetchLatestBasicSensorDataFromStation(selectedStation.stationID);
    ApiModel_SensorReadingEntry rawData = await rawDataFuture;

    selectedStationLatestSensorEntry = rawData;
    debugPrint("Payload${selectedStationLatestSensorEntry.payload}");
    selectedStationLatestData = jsonDecode(selectedStationLatestSensorEntry.payload);
    return true;
  }

  Future<bool> LoadReadingsList(String stationID) async {
    Future<List<ApiModel_SensorReadingEntry>> rawDataFuture =
        _logic_sensorData.fetchWindowOfEntries(selectedStartDate, selectedEndDate, stationID);

    listOfEntries = await rawDataFuture;

    return listOfEntries.isNotEmpty;
  }

  Future<List<Widget>> transformRawStationListData() async {
    List<Widget> result = [];

    result.add(DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        'Other stations',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    ));

    Future<bool> dataLoadedFlagFuture;
    bool dataLoaded = false;
    if (stationList.isEmpty) {
      dataLoadedFlagFuture = LoadStationList();
      dataLoaded = await dataLoadedFlagFuture;
    } else {
      dataLoaded = true;
    }

    if (dataLoaded) {
      for (ApiModel_BasicStationInfo entry in stationList) {
        ListTile listItem = ListTile(title: Text(entry.stationName));
        result.add(listItem);
      }

      return result;
    } else {
      return [];
    }
  }

  Future<ApiModel_BasicStationInfo> loadSelectedStationData() async {
    Future<bool> dataLoadedFlagFuture;
    bool dataLoaded = false;
    if (stationList.isEmpty) {
      dataLoadedFlagFuture = LoadStationList();
      dataLoaded = await dataLoadedFlagFuture;
    } else {
      dataLoaded = true;
    }
    if (dataLoaded) {
      return selectedStation;
    } else {
      return ApiModel_BasicStationInfo("", "Failed to load", 0, 0, DateTime.now(), "[]");
    }
  }

  List<String> _transformSupportedMeasurements() {
    List<String> result = [];
    for (dynamic item in jsonDecode(selectedStation.supportedMeasurements)) {
      result.add(item as String);
    }

    return result;
  }

  Future<List<String>> transformSupportedMeasurementList() async {
    Future<bool> dataLoadedFlagFuture;
    bool dataLoaded = false;
    if (stationList.isEmpty) {
      dataLoadedFlagFuture = LoadStationList();
      dataLoaded = await dataLoadedFlagFuture;
    } else {
      dataLoaded = true;
    }

    if (dataLoaded) {
      List<String> result = [];
      for (dynamic item in jsonDecode(selectedStation.supportedMeasurements)) {
        result.add(item as String);
      }
      selectedMeasurement = result[0];
      reloadChart();
      return result;
    } else {
      return ["Failed to load."];
    }
  }

  Future<List<TimeSeries>> generateChartData() async {
    debugPrint("Generating chart data");
    List<TimeSeries> result = [];

    Future<bool> dataLoadedFlagFuture;
    bool dataLoaded = false;

    if (listOfEntries.isEmpty) {
      dataLoadedFlagFuture = LoadReadingsList(selectedStation.stationID);
      dataLoaded = await dataLoadedFlagFuture;
    } else {
      dataLoaded = true;
    }

    debugPrint("List of entries length: ${listOfEntries.length}");


    if (dataLoaded) {
      debugPrint("Data is loaded");
      for (ApiModel_SensorReadingEntry entry in listOfEntries) {
        Map<String, dynamic> payload = jsonDecode(entry.payload);
        String? valueFromPayload = payload[selectedMeasurement];
        TimeSeries chartValue;
        if (valueFromPayload != null) {
          debugPrint("Temp value: ${valueFromPayload} datetime ${entry.timeOfCapture}");
          chartValue = TimeSeries(entry.timeOfCapture, double.parse(valueFromPayload));
        } else {
          chartValue = TimeSeries(entry.timeOfCapture, 1);
        }

        result.add(chartValue);
      }
      return result;
    } else {
      return [];
    }
  }

  void ChangeSelectedStation(int index) {
    selectedStation = stationList[index];
    notifyListeners();
  }

  void reloadChart() async {
    Future<List<TimeSeries>> rawDataFuture;
    rawDataFuture = generateChartData();
    chartData = await rawDataFuture;
    notifyListeners();

  }

  void updateSelectedMeasurement(String value) {
    selectedMeasurement = value;
    chartData = [];
    reloadChart();
    notifyListeners();
  }

  void updateDates (DateTime newStart, DateTime newEnd) {
    selectedStartDate = newStart;
    selectedEndDate = newEnd;
    listOfEntries = [];
    chartData = [];
    reloadChart();
    notifyListeners();
  }

}
