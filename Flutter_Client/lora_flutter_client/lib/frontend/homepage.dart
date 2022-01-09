import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Sofia", style: TextStyle(fontSize: 42)),
          Text("Last update:", style: TextStyle(fontSize: 16)),
          Text(" XX min ago", style: TextStyle(fontSize: 16)),
          Padding(
            padding: EdgeInsets.only(top: 150),
            child: Text(
              "Avg. Temperature",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "20C ",
            style: TextStyle(fontSize: 124),
            textAlign: TextAlign.center,
          ),
          Text(
            "Avg. Humidity",
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              "20%",
              style: TextStyle(fontSize: 124),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    ));
  }
}
