// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicLatestSensorReadings.dart';
import 'package:lora_flutter_client/backend/SensorDataModel.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Consumer<SensorDataModel>(
        builder: (context, dataMode, child) {
          return FutureProvider<ApiModel_BasicLatestSensorReadings>(
              create: (context) => dataMode.getNewData(),
              initialData: ApiModel_BasicLatestSensorReadings(0, 0, "N/A"),
              child: Consumer<ApiModel_BasicLatestSensorReadings>(
                builder: (context, loadedModel, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 42.0),
                        child: Text("Sofia", style: TextStyle(fontSize: 42)),
                      ),
                      Text("Last update:", style: TextStyle(fontSize: 16)),
                      (loadedModel.lastUpdate == "N/A")
                          ? Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Container(
                                  height: 42, width: 42, child: CircularProgressIndicator()),
                            )
                          : Text(loadedModel.lastUpdate, style: TextStyle(fontSize: 16)),
                      Padding(
                        padding: EdgeInsets.only(top: 124),
                        child: Text(
                          "Avg. Temperature",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      (loadedModel.averageTemperature == 0)
                          ? Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Container(
                                  height: 50, width: 50, child: CircularProgressIndicator()),
                            )
                          : Text(
                              loadedModel.averageTemperature.toString(),
                              style: TextStyle(fontSize: 124),
                              textAlign: TextAlign.center,
                            ),
                      Text(
                        "Avg. Humidity",
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                      (loadedModel.averageTemperature == 0)
                          ? Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Container(
                                  height: 50, width: 50, child: CircularProgressIndicator()),
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 50),
                              child: Text(
                                loadedModel.averageHumidity.toString(),
                                style: TextStyle(fontSize: 124),
                                textAlign: TextAlign.center,
                              ),
                            )
                    ],
                  );
                },
              ));
        },
      ),
    ));
  }
}