import 'dart:async';
import 'package:VJIT/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './ControlFilter.dart';
import './SelectBondedDevicePage.dart';
import './connectionState.dart' as cs;

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  cs.ConnectionState _connectionState = cs.ConnectionState();

  String _address = "...";
  String _name = "...";

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  // // This code is just a example if you need to change page and you need to communicate to the raspberry again
  // void init() async {
  //   Communication com = Communication();
  //   await com.connectBl(_address);
  //   com.sendDataToVjit("Hello");
  //   setState(() {});
  // }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Connexion au boitier VJIT',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListTile(title: const Text('Général')),
          SwitchListTile(
            activeColor: Color.fromRGBO(251, 101, 128, 1),
            title: const Text('Activer Bluetooth'),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              // Do the request and update with the true value then
              future() async {
                // async lambda seems to not working
                if (value)
                  await FlutterBluetoothSerial.instance.requestEnable();
                else
                  await FlutterBluetoothSerial.instance.requestDisable();
              }

              future().then((_) {
                setState(() {});
              });
            },
          ),
          ListTile(
            title: const Text('Statut Bluetooth'),
            subtitle: Text(_bluetoothState.toString()),
            trailing: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 5.0)
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Color.fromRGBO(251, 101, 128, 1),
                    Color.fromRGBO(241, 23, 117, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Text('Paramètre'),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
          ),
          ListTile(
            title: const Text("Adresse local de l'appareil"),
            subtitle: Text(_address),
          ),
          ListTile(
            title: const Text("Nom local de l'appareil"),
            subtitle: Text(_name),
            onLongPress: null,
          ),
          Divider(),
          ListTile(title: const Text('Chercher et connexion au boitier')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 5.0)
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Color.fromRGBO(251, 101, 128, 1),
                    Color.fromRGBO(241, 23, 117, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Text('Connexion au boitier VJIT'),
                onPressed: () async {
                  if (!_connectionState.isConnected.value) {
                    _showError(context);
                  } else {
                    final BluetoothDevice selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectBondedDevicePage(
                              checkAvailability: false);
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Connect -> selected ' + selectedDevice.address);
                      _controlFilters(context, selectedDevice);
                    } else {
                      print('Connect -> no device selected');
                    }
                  }
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  void _controlFilters(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ControlFilter(
            server: server,
          );
        },
      ),
    );
  }

  static void _showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur connexion'),
          content: Text("Veuillez vous connecter."),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
              },
            ),
          ],
        );
      },
    );
  }
}
