import 'dart:typed_data';
import 'dart:convert';
import 'filters/filter.dart';
import 'package:http/http.dart' as http;
import 'filters/filterRepo.dart' as FilterRepo;
import 'package:flutter/material.dart';
import './connectionState.dart' as cs;

class AllFiltersPage extends StatefulWidget {
  const AllFiltersPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AllFiltersPageState();
}

class _AllFiltersPageState extends State<AllFiltersPage> {
  cs.ConnectionState _connectionState = cs.ConnectionState();

  Future getFilters() async {
    Uri url = Uri.parse('http://10.0.2.2:3000/api/user/3/userjson');

    Object data = {
      "token": _connectionState.token,
    };

    try {
      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      if (response.statusCode != 200) {
        Map res = json.decode(response.body);
        String msg = 'Unknown error';
        if (res.containsKey('message')) {
          msg = res['message'];
        } else if (response.reasonPhrase != '') {
          msg = response.reasonPhrase;
        }
        print(msg);
      } else {
        Map res = json.decode(response.body);
        List<Filter> filters = [];
        for (var f in res['filters']) {
          filters.add(Filter.fromJson(f));
        }

        return filters;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Filters'),
      ),
      body: FutureBuilder<List<Filter>>(
        future: getFilters(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),

                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addFilter');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
