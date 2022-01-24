// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicStationInfo.dart';
import 'package:lora_flutter_client/backend/StationDataModel.dart';
import 'package:lora_flutter_client/utilityclasses/string_capitalization.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../backend/SensorDataModel.dart';
import 'TimelineSeriesChart.dart';

/// Sample ordinal data type.
/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class StationsPage extends StatelessWidget {
  // This widget is the root of your application.

  /// Create one series with sample hard coded data.
  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StationDataModel>(
      builder: (context, rootModel, child) {
        return FutureProvider<ApiModel_BasicStationInfo>(
            create: (context) => {},
            // ignore: prefer_const_literals_to_create_immutables
            initialData:
            ApiModel_BasicStationInfo("", "Loading...", 0, 0, DateTime.now(), "[]"),
            child: Consumer<ApiModel_BasicStationInfo>(
              builder: (context, loadedModel, child) {
                return Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      iconTheme: IconThemeData(color: Colors.blue, size: 30),
                    ),
                    drawer: Drawer(
                      child: Padding(
                          padding: EdgeInsets.zero,
                          child: Consumer<StationDataModel>(
                            builder: (context, dataMode, child) {
                              return FutureProvider<List<Widget>>(
                                  create: (context) => dataMode.transformRawStationListData(),
                                  // ignore: prefer_const_literals_to_create_immutables
                                  initialData: [
                                    ListTile(
                                      title: Text(
                                        "Loading...",
                                        style: GoogleFonts.kanit(
                                          fontSize: 18,
                                          color: Colors.blue[900],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 100.0, right: 100.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  ],
                                  child: Consumer<List<Widget>>(
                                    builder: (context, loadedModel, child) {
                                      return ListView(
                                        children: loadedModel,
                                      );
                                    },
                                  ));
                            },
                          )),
                    ),
                    body: SingleChildScrollView(
                      child: Center(
                        child:(!rootModel.canShowUI) ? CircularProgressIndicator() : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  rootModel.selectedStation.stationName,
                                  style: GoogleFonts.kanit(
                                      fontSize: 60,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w700),
                                )),
                            Text(
                              "Last update:",
                              style: GoogleFonts.kanit(
                                fontSize: 18,
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              rootModel.selectedStation.lastSeen.toString(),
                              style: GoogleFonts.kanit(
                                fontSize: 16,
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 42),
                              child: Text(
                                "Live Data",
                                style: GoogleFonts.kanit(
                                    fontSize: 25,
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            (rootModel.selectedStationLatestData.isNotEmpty)
                                ? Text(
                              rootModel
                                  .selectedStationLatestData[rootModel.selectedMeasurement],
                              style: GoogleFonts.kanit(
                                  fontSize: 100,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            )
                                : Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: DropdownWidget(),
                            ),
                            DatePickers(),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                  height: 200,
                                  width: 350,
                                  child: SimpleTimeSeriesChart(loadedModel.stationID)),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ));
      },
    );
  }
}

class DatePickers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DatePickersSatate();
  }
}

class _DatePickersSatate extends State<DatePickers> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}",
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton(
                    onPressed: () => pickDate(context, true),
                    child: Text("Start Date",
                        style: GoogleFonts.kanit(
                            fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[50], shadowColor: Colors.blue[700])),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}",
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton(
                    onPressed: () => pickDate(context, false),
                    child: Text("End Date",
                        style: GoogleFonts.kanit(
                            fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[50], shadowColor: Colors.blue[700]))
              ],
            )
          ],
        ),
        ElevatedButton(
            onPressed: () {
              Provider.of<StationDataModel>(context, listen: false)
                  .updateDates(selectedStartDate, selectedEndDate);
            },
            child: Text("Fetch data",
                style: GoogleFonts.kanit(
                    fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.w400)),
            style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue[50], shadowColor: Colors.blue[700])),
        Consumer<StationDataModel>(
          builder: (context, dataModel, child) {
            return (dataModel.chartData.isEmpty)
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    "Loading...",
                    style: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(height: 20, width: 20, child: CircularProgressIndicator())
              ],
            )
                : Container();
          },
        )
      ],
    );
  }

  Future pickDate(BuildContext context, bool pickingStartDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.input,
    );

    if (selectedDate == null) {
      return;
    }

    if (pickingStartDate) {
      setState(() {
        selectedStartDate = selectedDate;
      });
    } else {
      setState(() {
        selectedEndDate = selectedDate;
      });
    }
  }
}

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({Key? key}) : super(key: key);

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String dropdownValue = '';
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<StationDataModel>(
      builder: (context, stationDataModel, child) {
        return  (stationDataModel.supportedMeasurementStringList.isNotEmpty) ? DropdownButton<String>(
          value: (stationDataModel.canShowDrop) ? stationDataModel.selectedMeasurement : "",
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.blueAccent,
          ),
          elevation: 16,
          style: const TextStyle(color: Colors.blue),
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
              debugPrint("VALUE: ${dropdownValue}");
              stationDataModel.updateSelectedMeasurement(dropdownValue);
            });
          },
          items: stationDataModel.supportedMeasurementStringList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(left: 0, top: 8, bottom: 8, right: 54),
                child: Text(
                    value[0].toUpperCase() +
                        value.substring(
                          1,
                        ),
                    style: GoogleFonts.kanit(
                        fontSize: 20,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w400)),
              ),
            );
          }).toList(),
        ) : Text("Loading...", style: GoogleFonts.kanit(
          fontSize: 18,
          color: Colors.blue[900],
          fontWeight: FontWeight.w500,
        ));
      },
    );
  }
}

*/