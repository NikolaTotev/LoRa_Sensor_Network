import 'package:flutter/material.dart';

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
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Other stations',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
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
  String dropdownValue = 'Temperature';

  @override
  Widget build(BuildContext context) {
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
      items: <String>['Temperature', 'Humidity', 'Pressure', 'Air quality']
          .map<DropdownMenuItem<String>>((String value) {
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
  }
}
