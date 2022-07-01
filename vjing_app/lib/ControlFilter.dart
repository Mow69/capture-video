import 'dart:developer';
import 'dart:typed_data';
import 'dart:convert';
import 'filters/filter.dart';
import 'filters/filterRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ControlFilter extends StatefulWidget {
  final BluetoothDevice server;

  const ControlFilter({this.server});

  @override
  _ControlFilter createState() => new _ControlFilter();
}

class _ControlFilter extends State<ControlFilter> {
  BluetoothConnection connection;

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
    var speed = 1.0;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mes Filtres"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text("Filter Loop",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20)),
                    Expanded(
                        child: Divider(
                      color: Colors.white,
                      thickness: 1,
                      indent: 5,
                    )),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: getFilters(context),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: asyncSnapshot.data.length,
                          itemBuilder: (context, index) {
                            Uint8List bytes =
                                base64Decode(asyncSnapshot.data[index].icon);
                            return GestureDetector(
                              onTap: () =>
                                  _sendMessage(asyncSnapshot.data[index].id),
                              child: GridTile(
                                child: Image.memory(
                                  bytes,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),
              Container(
                height: 59,
                decoration: BoxDecoration(color: Colors.grey[900]),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Vitesse"),
                    ),
                    Slider.adaptive(
                      activeColor: Color.fromRGBO(251, 101, 128, 1),
                      value: speed,
                      onChanged: (newSpeed) {
                        setState(() => speed = newSpeed);
                      },
                      min: 0.0,
                      max: 10, 
                    )
                  ],
                ),
                
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                  Container(
                    height: 70,
                    width: 88,
                    decoration: BoxDecoration(color: Colors.grey[900]),
                    child: Column(
                      children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Aléatoire",
                        style: TextStyle(fontSize: 12),),
                      ),
                      Icon(Icons.shuffle,
                        color: Colors.grey[600],
                      )
                    ],),
                    ),
                  Container(
                    height: 70,
                    width: 88,
                    decoration: BoxDecoration(color: Colors.grey[900]),
                    child: Column(
                      children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pause",
                        style: TextStyle(fontSize: 12),),
                      ),
                      Icon(Icons.pause,
                        color: Colors.grey[600],
                      )
                    ],),
                    ),
                    Container(
                    height: 70,
                    width: 88,
                    decoration: BoxDecoration(color: Colors.grey[900]),
                    child: Column(
                      children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Réinitialiser",
                        style: TextStyle(fontSize: 12),),
                      ),
                      Icon(Icons.refresh,
                        color: Colors.grey[600],
                      )
                    ],),
                    ),
                ],),
              )
            ],
          ),
        ));
  }

  void _sendMessage(int int) async {
    String text = int.toString();
    // textEditingController.clear();

    if (text.length > 0) {
      try {
        print("envoyé");
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
