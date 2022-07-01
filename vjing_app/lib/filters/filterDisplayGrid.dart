import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class FilterDisplayGrid extends StatefulWidget {
  FilterDisplayGrid(AsyncSnapshot asyncSnapshot);

  @override
  _FilterDisplayGrid createState() => new _FilterDisplayGrid();
}

class _FilterDisplayGrid extends State<FilterDisplayGrid> {
  AsyncSnapshot<dynamic> asyncSnapshot;
  @override
  Widget build(BuildContext context) {
      inspect(asyncSnapshot);
    GridView.builder(
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
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
    throw UnimplementedError();
  }
}
