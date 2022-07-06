import 'package:flutter/material.dart';

import 'MainPage.dart';

void main() => runApp(new Application());

Map<int, Color> colorCodes = {
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
MaterialColor pika = MaterialColor(0xfb6580, colorCodes);

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.red,
          ),
    );
  }
}
