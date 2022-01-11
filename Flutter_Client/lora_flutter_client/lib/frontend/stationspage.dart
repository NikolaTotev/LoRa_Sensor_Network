// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_BasicStationInfo.dart';
import 'package:lora_flutter_client/backend/StationDataModel.dart';
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
      builder: (context, dataModel, child) {
        return FutureProvider<ApiModel_BasicStationInfo>(
            create: (context) => dataModel.loadSelectedStationData(),
            // ignore: prefer_const_literals_to_create_immutables
            initialData:
                ApiModel_BasicStationInfo("", "Failed to load", 0, 0, DateTime.now(), "[]"),
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
                                      title: Text("Loading..."),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child:
                                    Text(loadedModel.stationName, style: TextStyle(fontSize: 42))),
                            Text("Last seen:", style: TextStyle(fontSize: 16)),
                            Text(loadedModel.lastSeen.toString(), style: TextStyle(fontSize: 16)),
                            Padding(
                              padding: EdgeInsets.only(top: 42),
                              child: Text(
                                "Live Data",
                                style: TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              "20C ",
                              style: TextStyle(fontSize: 124),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: DropdownWidget(),
                            ),
                            DatePickers(),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                height: 200,
                                width: 350,
                                child: SimpleTimeSeriesChart(loadedModel.stationID)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}"),
            TextButton(onPressed: () => pickDate(context, true), child: Text("Start Date")),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child:
                  Text("${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}"),
            ),
            TextButton(onPressed: () => pickDate(context, false), child: Text("End Date"))
          ],
        ),
        TextButton(
            onPressed: () {
              Provider.of<StationDataModel>(context, listen: false)
                  .updateDates(selectedStartDate, selectedEndDate);
            },
            child: Text("Fetch data")),
        Consumer<StationDataModel>(
          builder: (context, dataModel, child) {
            return (dataModel.chartData.isEmpty) ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [Padding(
              padding: const EdgeInsets.only(right:16.0),
              child: Text("Loading..."),
            ), Container(height: 20, width: 20, child: CircularProgressIndicator())],) : Container();
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
  String dropdownValue = 'Loading...';
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<StationDataModel>(
      builder: (context, stationDataModel, child) {
        return FutureProvider<List<String>>(
            create: (context) => stationDataModel.transformSupportedMeasurementList(),
            // ignore: prefer_const_literals_to_create_immutables
            initialData: ["Loading..."],
            child: Consumer<List<String>>(
              builder: (context, loadedModel, child) {
                loaded = true;
                return DropdownButton<String>(
                  value: stationDataModel.selectedMeasurement,
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
                  items: loadedModel.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, top: 8, bottom: 8, right: 54),
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ));
      },
    );
  }
}
