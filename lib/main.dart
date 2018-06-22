import 'package:flutter/material.dart';
import 'package:weatherapp/ui/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Weather App",
      theme: new ThemeData(
        primarySwatch: Colors.pink
      ),
      home: new Home(),
    );
  }
  
}