import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './connectionState.dart' as cs;
import 'LoginPage.dart';
import 'RegisterPage.dart';

class DrawerMenu extends StatelessWidget {
  cs.ConnectionState _connectionState = cs.ConnectionState();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 10.0),
                  child: SvgPicture.asset(
                    'assets/images/logo-shadow.svg',
                    semanticsLabel: 'logo',
                    height: 60,
                  )
                ),
                Text(
                  'VJIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [
                  Color.fromRGBO(239, 77, 105, 1.0),
                  Color.fromRGBO(150, 13, 71, 1.0),
                ],
              )
              //color: Color.fromRGBO(251, 101, 128, .8),
            ),
          ),
          if (!_connectionState.isConnected.value) ...[
            ListTile(
              title: Text('Connexion'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Inscription'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
            ),
          ]
        ],
      ),
    );
  }
}
