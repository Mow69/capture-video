import 'package:flutter/material.dart';
import './home.dart';

void main() => runApp(new Application());

class Application extends StatelessWidget {

  final Map<int, Color> colorCodes = {
    50: Color.fromRGBO(251, 101, 128, .1),
    100: Color.fromRGBO(251, 101, 128, .2),
    200: Color.fromRGBO(251, 101, 128, .3),
    300: Color.fromRGBO(251, 101, 128, .4),
    400: Color.fromRGBO(251, 101, 128, .5),
    500: Color.fromRGBO(251, 101, 128, .6),
    600: Color.fromRGBO(251, 101, 128, .7),
    700: Color.fromRGBO(251, 101, 128, .8),
    800: Color.fromRGBO(251, 101, 128, .9),
    900: Color.fromRGBO(251, 101, 128, 1),
  };
  // pink color code: fb6580


  @override
  Widget build(BuildContext context) {
    MaterialColor pika = MaterialColor(0xfb6580, colorCodes);
    return MaterialApp(
      home: Home(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: pika[900],
          highlightColor: pika[900],
        
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary:  pika[900], // background (button) color
              onPrimary: Colors.white, 
              elevation: 0.0,      
              ),
          ),
        ),
    );
  }
}
