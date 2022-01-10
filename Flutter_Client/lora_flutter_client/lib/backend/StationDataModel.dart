// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicLatestSensorReadings.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicStationInfo.dart';
import 'package:lora_flutter_client/backend/ApiLogic_SensorData.dart';
import 'package:lora_flutter_client/backend/ApiLogic_StationData.dart';
import 'dart:convert';

class StationDataModel extends ChangeNotifier {
  ApiLogic_StationData _logic_stationData = ApiLogic_StationData();

  late ApiModel_BasicStationInfo selectedStation;
  List<ApiModel_BasicStationInfo> stationList = [];

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
    return true;
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
    }
    else{dataLoaded=true;}
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
    }    else{dataLoaded=true;}

    if (dataLoaded) {
      List<String> result = [];
      for (dynamic item in jsonDecode(selectedStation.supportedMeasurements)) {
        result.add(item as String);
      }
      return result;
    } else {
      return ["Failed to load."];
    }
  }

  void ChangeSelectedStation(int index) {
    selectedStation = stationList[index];
    notifyListeners();
  }
}
