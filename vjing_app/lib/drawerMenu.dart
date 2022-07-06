import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'RegisterPage.dart';

class DrawerMenu extends StatelessWidget {
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
          ListTile(
            title: Text('Login'),
            onTap: () {
              // go to login page
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
      ),
    );
  }
}
