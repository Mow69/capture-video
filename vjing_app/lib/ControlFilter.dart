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
  double _speed = 5;
  bool _random = false;
  bool _pause = false;
  // bool _camera = true;
  var _randomColor = Colors.transparent;
  var _pauseColor = Colors.transparent;
  // var _cameraColor = Color.fromRGBO(251, 101, 128, 1);
  // IconData _cameraIcon = Icons.videocam_outlined;

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
    return filters;
  }

  @override
  Widget build(BuildContext context) {
    getFilters(context);

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
                        asyncSnapshot.data
                            .removeWhere((el) => el.category_name == 'flash');
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
                                base64Decode(asyncSnapshot.data[index].image);
                            return GestureDetector(
                              onTap: () {
                                String idString =
                                    asyncSnapshot.data[index].id.toString();
                                return _sendDataToVjit("filterId:$idString:");
                              },
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
                    Expanded(
                      child: Slider.adaptive(
                        activeColor: Color.fromRGBO(251, 101, 128, 1),
                        min: 0,
                        max: 10,
                        divisions: 10,
                        value: _speed,
                        onChanged: (value) {
                          setState(() {
                            _speed = value;
                          });
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            int _speedInt = value.toInt();
                            _sendDataToVjit("speed:$_speedInt:");
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _random = !_random;
                        _sendDataToVjit("random:$_random:");
                        setState(() {
                          _randomColor = _random == false
                              ? Colors.transparent
                              : Color.fromRGBO(251, 101, 128, 1);
                        });
                      },
                      child: Container(
                        height: 70,
                        width: 88,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          border: Border.all(
                            color: _randomColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Aléatoire",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Icon(
                              Icons.shuffle,
                              color: Colors.grey[600],
                            )
                          ],
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     _camera = !_camera;
                    //     _sendDataToVjit("camera:$_camera:");
                    //     setState(() {
                    //       _cameraColor = _camera == false
                    //           ? Colors.transparent
                    //           : Color.fromRGBO(251, 101, 128, 1);
                    //       _cameraIcon = _camera == false
                    //           ? Icons.videocam_off_outlined
                    //           : Icons.videocam_outlined;
                    //     });
                    //   },
                    //   child: Container(
                    //     height: 70,
                    //     width: 88,
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey[900],
                    //       border: Border.all(
                    //         color: _cameraColor,
                    //       ),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(
                    //             "caméra",
                    //             style: TextStyle(fontSize: 12),
                    //           ),
                    //         ),
                    //         Icon(
                    //           _cameraIcon,
                    //           color: Colors.grey[600],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        _pause = !_pause;
                        _sendDataToVjit("pause:$_pause:");
                        setState(() {
                          _pauseColor = _pause == false
                              ? Colors.transparent
                              : Color.fromRGBO(251, 101, 128, 1);
                        });
                      },
                      child: Container(
                        height: 70,
                        width: 88,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          border: Border.all(
                            color: _pauseColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Pause",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Icon(
                              Icons.pause,
                              color: Colors.grey[600],
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _sendDataToVjit("reset:true:");
                        setState(() {
                          _random = false;
                          // _camera = true;
                          _pause = false;
                          _speed = 5;
                          _randomColor = Colors.transparent;
                          // _cameraColor = Color.fromRGBO(251, 101, 128, 1);
                          // _cameraIcon = Icons.videocam_outlined;
                          _pauseColor = Colors.transparent;
                        });
                      },
                      child: Container(
                        height: 70,
                        width: 88,
                        decoration: BoxDecoration(color: Colors.grey[900]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Réinitialiser",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Icon(
                              Icons.refresh,
                              color: Colors.grey[600],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text("Filter Flash",
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
                        asyncSnapshot.data
                            .removeWhere((el) => el.category_name == 'filter');
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
                                base64Decode(asyncSnapshot.data[index].image);
                            return GestureDetector(
                              onTap: () {
                                String idString =
                                    asyncSnapshot.data[index].id.toString();
                                return _sendDataToVjit("flashId:$idString:");
                              },
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
            ],
          ),
        ));
  }

  void _sendDataToVjit(String text) async {
    print(text);
    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text));
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
