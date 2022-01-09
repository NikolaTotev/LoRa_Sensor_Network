import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: const [
        Text("Location Name"),
        Text("Last update XX min ago"),
        Text("20C "),
        Text("20%")
      ],
    ));
  }
}
