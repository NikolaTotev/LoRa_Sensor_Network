// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicLatestSensorReadings.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicStationInfo.dart';
import 'package:lora_flutter_client/backend/ApiLogic_SensorData.dart';
import 'package:lora_flutter_client/backend/ApiLogic_StationData.dart';

class StationDataModel extends ChangeNotifier {
  ApiLogic_StationData _logic_stationData = ApiLogic_StationData();

  Future<List<dynamic>> getStationList() {
    return _logic_stationData.fetchLatestBasicSensorData();
  }

  Future<List<Widget>> transformRawStationListData() async {
    Future<List<dynamic>> rawDataFuture = getStationList();

    List<dynamic> rawData = await rawDataFuture;

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

    for(dynamic entry in rawData){
      ApiModel_BasicStationInfo stationInfo = ApiModel_BasicStationInfo.fromJson(entry);
      ListTile listItem = ListTile(title:Text(stationInfo.stationName));
      result.add(listItem);
    }

    return result;
  }
}
