import 'dart:convert';
import 'package:flutter/cupertino.dart';
import './filter.dart';
import 'package:http/http.dart' as http;
import '../connectionState.dart' as cs;

class FilterRepository {
  Future<List<Filter>> getAll(BuildContext context) async {
    cs.ConnectionState _connectionState = cs.ConnectionState();
    Uri url = Uri.parse('http://164.92.201.208:3000/api/user/userjson/downloaded');

    String token = _connectionState.token.value;
    try {
      http.Response response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'bearer $token'
          });
      print(response);
      if (response.statusCode != 200) {
        var res = json.decode(response.body);
        String msg = 'Unknown error';
        if (res.containsKey('message')) {
          msg = res['message'];
        } else if (response.reasonPhrase != '') {
          msg = response.reasonPhrase;
        }
        print(msg);
      } else {
        final filters = parseData(response.body);


        return filters;
      }
    } catch (e) {
      print(e);
    }

    return null;
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
