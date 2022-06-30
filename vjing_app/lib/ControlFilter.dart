import 'dart:developer';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'filters/filter.dart';
import 'filters/filterRepo.dart';

class ControlFilter extends StatefulWidget {
  final BluetoothDevice server;

  const ControlFilter({this.server});

  @override
  _ControlFilter createState() => new _ControlFilter();
}

class _ControlFilter extends State<ControlFilter> {
  BluetoothConnection connection;
  // final filters = new FilterRepository();

  // Fetch content from the json file

  // Future<void> readJson() async {
  //   final String response =
  //       await rootBundle.loadString('assets/MOCK_DATA.json');
  //   final data = await json.decode(response);
  //   print("COUCOUUUUUUUU");
  //   print(data);
  //   setState(() {});
  //   return filters = data["items"];
  // }

  List<Card> filterWidget = [];
  // List<Filter> filters = [];
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  @override
  void initState() {
    super.initState();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
      });
      //  connection.input.listen(_onDataReceived).onDone(() {
      //       // Example: Detect which side closed the connection
      //       // There should be `isDisconnecting` flag to show are we are (locally)
      //       // in middle of disconnecting process, should be set before calling
      //       // `dispose`, `finish` or `close`, which all causes to disconnect.
      //       // If we except the disconnection, `onDone` should be fired as result.
      //       // If we didn't except this (no flag set), it means closing by remote.
      //         // if (isDisconnecting) {
      //         //   print('Disconnecting locally!');
      //         // } else {
      //         //   print('Disconnected remotely!');
      //         // }
      //       if (this.mounted) {
      //         setState(() {});
      //       }
      //     });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  getFilters(context) async {
    List<Filter> filters = await FilterRepository().getAll(context);
    inspect(filters);
    return filters;
  }

  @override
  Widget build(BuildContext context) {
    getFilters(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mes Filtres"),
        ),
        body: FutureBuilder(
            future: getFilters(context),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: asyncSnapshot.data.length,
                  itemBuilder: (context, index) {
                   
                    Uint8List bytes = base64Decode(asyncSnapshot.data[index].icon);
                    return GestureDetector(
                      onTap: () => print(asyncSnapshot.data[index].id),
                      child: GridTile(
                        child: Image.memory(bytes)
                      ),
                      
                    );
                  },
                );
              }
            }));
  }
}
