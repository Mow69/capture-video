import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_VJing/filters/filter.dart';

class FilterRepository {
  Future<List<Filter>> getAll(BuildContext context) async {
    print("AVANT FILTER");

    final filterJson = await DefaultAssetBundle.of(context)
        .loadString("assets/MOCK_DATA.json");
    final filterList = parseData(filterJson.toString());
    print("ICIIIIIIIII");
    return filterList;
  }

  List<Filter> parseData(String response) {
    final parsed = jsonDecode(response.toString()).cast<Map<String, Object>>();
    parsed.sort((a, b) => a['name']
        .toString()
        .toLowerCase()
        .compareTo(b['name'].toString().toLowerCase()));
    print("BONJOUUUUUUUUR");
    return parsed.map<Filter>((json) => new Filter.fromJson(json)).toList();
  }
}
