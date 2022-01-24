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
  Map<String, dynamic> selectedStationLatestData = {};
  List<ApiModel_BasicStationInfo> stationList = [];
  List<TimeSeries> chartData = [];
  List<ApiModel_SensorReadingEntry> listOfEntries = [];
  String selectedMeasurement = "";
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  bool canShowUI = false;
  bool canShowDrop = false;

  Future<List<dynamic>> getStationList() {
    return _logic_stationData.fetchStationList();
  }

  Future<bool> LoadStationList() async {
    Future<List<dynamic>> rawDataFuture = getStationList();
    List<dynamic> rawData = await rawDataFuture;
    stationList.clear();
    for (dynamic entry in rawData) {
      ApiModel_BasicStationInfo stationInfo = ApiModel_BasicStationInfo.fromJson(entry);
      stationList.add(stationInfo);
      debugPrint("Adding station ${stationInfo.stationName}");
    }
    selectedStation = stationList[0];
    return true;
  }

  Future<bool> LoadLatestStationData() async {
    Future<ApiModel_SensorReadingEntry> rawDataFuture =
        _logic_sensorData.fetchLatestBasicSensorDataFromStation(selectedStation.stationID);
    ApiModel_SensorReadingEntry rawData = await rawDataFuture;

    selectedStationLatestSensorEntry = rawData;
    selectedStationLatestData = jsonDecode(selectedStationLatestSensorEntry.payload);
    return true;
  }

  ///Loaded when "fetch data" btn is pressed.
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
        ListTile listItem = ListTile(
          title: Text(entry.stationName),
          onTap: () {
            LoadStationData(stationList.indexOf(entry));
          },
        );
        result.add(listItem);
      }

      return result;
    } else {
      return [];
    }
  }

  Future<bool> loadSelectedStationData() async {
    Future<bool> dataLoadedFlagFuture;
    bool dataLoaded = false;
    if (stationList.isEmpty) {
      dataLoadedFlagFuture = LoadStationList();
      dataLoaded = await dataLoadedFlagFuture;
    } else {
      dataLoaded = true;
    }
    if (dataLoaded) {
      dataLoaded = false;

      dataLoadedFlagFuture = LoadLatestStationData();
      dataLoaded = await dataLoadedFlagFuture;

      if (dataLoaded) {
        dataLoaded = false;

        dataLoadedFlagFuture = LoadReadingsList(selectedStation.stationID);
        dataLoaded = await dataLoadedFlagFuture;
        if (dataLoaded) {
          Future<List<String>> supportedMeasurements = transformSupportedMeasurementList();
          supportedMeasurementStringList = await supportedMeasurements;

          if (supportedMeasurementStringList.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  List<String> supportedMeasurementStringList = [];

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
    List<TimeSeries> result = [];

    Future<bool> dataLoadedFlagFuture;
    bool dataLoaded = false;

    if (listOfEntries.isEmpty) {
      dataLoadedFlagFuture = LoadReadingsList(selectedStation.stationID);
      dataLoaded = await dataLoadedFlagFuture;
    } else {
      dataLoaded = true;
    }

    if (dataLoaded) {
      for (ApiModel_SensorReadingEntry entry in listOfEntries) {
        Map<String, dynamic> payload = jsonDecode(entry.payload);
        String? valueFromPayload = payload[selectedMeasurement];
        TimeSeries chartValue;
        if (valueFromPayload != null) {
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

  Future<bool> InitialDataLoad() async {
    Future<bool> dataLoadedFuture = loadSelectedStationData();
    bool dataLoaded = await dataLoadedFuture;

    if (dataLoaded) {
      canShowUI = true;
      return true;
    } else {
      canShowUI = false;
      return false;
    }
  }

  void LoadStationData(int index) async {
    debugPrint("Switing to station ${stationList[index].stationName}");
    canShowUI = false;
    notifyListeners();

    Future<bool> dataLoadedFuture = loadSelectedStationData();
    bool dataLoaded = await dataLoadedFuture;
    selectedStation = stationList[index];
    updateSelectedMeasurement(selectedStation.supportedMeasurements[index]);
    selectedMeasurement = supportedMeasurementStringList[0];
    debugPrint(jsonEncode(selectedStation.supportedMeasurements));
    debugPrint(jsonEncode(selectedStationLatestData));
    debugPrint(selectedMeasurement);

    if (dataLoaded) {
      canShowUI = true;
    } else {
      canShowUI = false;
    }
    notifyListeners();

    reloadChart();
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

  void updateDates(DateTime newStart, DateTime newEnd) {
    selectedStartDate = newStart;
    selectedEndDate = newEnd;
    listOfEntries = [];
    chartData = [];
    reloadChart();
    notifyListeners();
  }
}
