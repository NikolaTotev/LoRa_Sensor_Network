import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lora_flutter_client/backend/StationDataModel.dart';
import 'package:lora_flutter_client/frontend/stationdatapage.dart';
import 'package:lora_flutter_client/frontend/stationspage.dart';
import 'package:provider/provider.dart';
import 'backend/SensorDataModel.dart';
import 'frontend/homepage.dart';
import 'package:flutter/services.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue[800], // navigation bar color
    statusBarColor: Colors.blue[800], // status bar color
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SensorDataModel()),
        ChangeNotifierProvider(create: (context) => StationDataModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light, // 2
          ),
        ),
        home: MyStatefulWidget());
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[Homepage(), StationDataPage(), Homepage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.podcasts),
            label: 'Stations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'History',
          ),
        ],
        selectedLabelStyle: GoogleFonts.kanit(
          fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.w800),
        unselectedLabelStyle:  GoogleFonts.kanit(
            fontSize: 14, color: Colors.blue[500], fontWeight: FontWeight.w400),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.blue[400],
        onTap: _onItemTapped,
      ),
    );
  }
}
