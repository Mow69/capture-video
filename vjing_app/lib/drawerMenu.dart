import 'package:flutter/material.dart';
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
            child: Text(
              'VJing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(251, 101, 128, .8),
            ),
          ),

         if(!_connectionState.isConnected.value)
           ...[ListTile(
            title: Text('Login'),
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
            title: Text('Register'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ),
              );
            },
          ),
          ],
        ],
      ),
    );
  }
}
