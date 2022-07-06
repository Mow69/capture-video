import 'package:vjing_app/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './drawerMenu.dart';

class Home extends StatefulWidget {
  final BluetoothDevice server;
  const Home({this.server});

  @override
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Mes Filtres"),
          leading: Container(),
        ),
        drawer: DrawerMenu(),
        body: MainPage(),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                iconSize: 40,
                showSelectedLabels: false,
                onTap: (int index) {
                  if (index == 0) {
                    // open the drawer
                    _scaffoldKey.currentState.openDrawer();
                  } else {
                    Navigator.pushNamed(context, '/');
                  }
                },
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.grey,
                    ),
                    label: "Menu",
                  ),
                  BottomNavigationBarItem(
                      icon: Image(
                          image: AssetImage("assets/images/logo_Vijit.png"),
                          height: 40),
                      label: "Home"),
                ]),
          ),
        ));
  }
}
