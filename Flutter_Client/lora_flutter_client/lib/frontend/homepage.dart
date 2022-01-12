// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicLatestSensorReadings.dart';
import 'package:lora_flutter_client/backend/SensorDataModel.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Consumer<SensorDataModel>(
        builder: (context, dataModel, child) {
          return FutureProvider<void>(
              create: (context) => dataModel.updateData(),
              initialData: ApiModel_BasicLatestSensorReadings(0, 0, DateTime.now().toString()),
              child: Consumer<void>(
                  builder: (context, loadedData, child) {
                return SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Sofia",
                            style: GoogleFonts.kanit(
                                fontSize: 60, color: Colors.blue[700], fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          "Last update:",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        (!dataModel.loaded)
                            ? Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Container(
                                    height: 42, width: 42, child: CircularProgressIndicator()),
                              )
                            : Text(
                                dataModel.latestData.lastUpdate,
                                style: GoogleFonts.kanit(
                                  fontSize: 16,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Text(
                            "Avg. Temperature °C",
                            style: GoogleFonts.kanit(
                                fontSize: 25, color: Colors.blue[900], fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        (!dataModel.loaded)
                            ? Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Container(
                                    height: 50, width: 50, child: CircularProgressIndicator()),
                              )
                            : Text(
                                dataModel.latestData.averageTemperature.toString(),
                                style: GoogleFonts.kanit(
                                    fontSize: 90,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Text(
                            "Avg. Humidity %",
                            style: GoogleFonts.kanit(
                                fontSize: 25, color: Colors.blue[900], fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        (!dataModel.loaded)
                            ? Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Container(
                                    height: 50, width: 50, child: CircularProgressIndicator()),
                              )
                            : Padding(
                                padding: EdgeInsets.only(bottom: 25),
                                child: Text(
                                  dataModel.latestData.averageHumidity.toString(),
                                  style: GoogleFonts.kanit(
                                      fontSize: 90,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                        ElevatedButton(
                            onPressed: () {dataModel.updateData();},
                            child: Text(
                              "Refresh",
                              style: GoogleFonts.kanit(
                                  fontSize: 16,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w400),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue[50], shadowColor: Colors.blue[700]))
                      ],
                    ),
                  ),
                );
              }));
        },
      ),
    ));
  }
}
