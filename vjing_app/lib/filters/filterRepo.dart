import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:vjing_app/filters/filter.dart';

class FilterRepository {
  Future<List<Filter>> getAll(BuildContext context) async {
    final filterJson =
        await DefaultAssetBundle.of(context).loadString("assets/filters.json");
    final filterList = parseData(filterJson.toString());
    return filterList;
  }

  List<Filter> parseData(String response) {
    final parsed = jsonDecode(response.toString()).cast<Map<String, Object>>();
    parsed.sort((a, b) => a['name']
        .toString()
        .toLowerCase()
        .compareTo(b['name'].toString().toLowerCase()));
    return parsed.map<Filter>((json) => new Filter.fromJson(json)).toList();
  }
}
