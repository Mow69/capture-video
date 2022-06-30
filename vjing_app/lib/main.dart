import 'package:flutter/material.dart';

import 'MainPage.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        primarySwatch: Colors.amber
   
  
      ),);
  }
}