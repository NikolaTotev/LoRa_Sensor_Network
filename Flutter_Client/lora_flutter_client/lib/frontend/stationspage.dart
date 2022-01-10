// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lora_flutter_client/backend/StationDataModel.dart';
import 'package:provider/provider.dart';

class StationsPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Align(
                  alignment: Alignment.topCenter,
                  child: Text("Station name", style: TextStyle(fontSize: 42))),
              Text("Last seen:", style: TextStyle(fontSize: 16)),
              Text("2 min ago", style: TextStyle(fontSize: 16)),
              Padding(
                padding: EdgeInsets.only(top: 142),
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
            ],
          ),
        ));
  }
}

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({Key? key}) : super(key: key);

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String dropdownValue = 'Loading...';

  @override
  Widget build(BuildContext context) {
    return Consumer<StationDataModel>(
      builder: (context, dataMode, child) {
        return FutureProvider<List<String>>(
            create: (context) => dataMode.transformSupportedMeasurementList(),
            // ignore: prefer_const_literals_to_create_immutables
            initialData: ["Loading..."],
            child: Consumer<List<String>>(
              builder: (context, loadedModel, child) {
                dropdownValue = loadedModel[0];

                return DropdownButton<String>(
                  value: dropdownValue,
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
