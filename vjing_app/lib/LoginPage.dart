/// Connection page to the api
/// we send the login and the password to the api
/// and we get the token

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import './connectionState.dart' as cs;

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  cs.ConnectionState _connectionState = cs.ConnectionState();

  String _login = '';
  String _password = '';

  Widget _buildLogin() {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          _login = value;
        },
        validator: (String value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your Email';
          }
          return null;
        });
  }

  Widget _buildPassword() {
    return TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          _password = value;
        },
        validator: (String value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Wrap(
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo.svg',
                        semanticsLabel: 'logo',
                        height: 60,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'VJIT',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  _buildLogin(),
                  _buildPassword(),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                      child: Container(
                        width: double.infinity,
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
                          child: const Text('Login'),
                          onPressed: () async {
                            if (_formKey.currentContext == null ||
                                !_formKey.currentState.validate()) {
                              return;
                            }

                            Uri url = Uri.parse(
                                'http://164.92.201.208:3000/api/auth/login');
                            Object data = {
                              "email": _login,
                              "password": _password,
                            };
                            try {
                              http.Response response = await http.post(url,
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(data));

                              if (response.statusCode != 201) {
                                String msg = 'Unknown error';
                                if (response.reasonPhrase != '') {
                                  msg = response.reasonPhrase;
                                }

                                _showError(context, msg);
                              } else {
                                print('Connected');
                                Map res = json.decode(response.body);
                                _connectionState
                                    .connect([_login, res['access_token']]);
                              }
                              print('Response status: ${response.statusCode}');
                              print('Response body: ${response.body}');
                              _showSuccess(context);
                            } catch (e) {
                              _showError(context, e.toString());
                            }
                          },
                        ),
                      )),
                ],
              ),
            ),
          )),
    );
  }

  static void _showError(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void _showSuccess(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succès'),
            content: Text('Connection établie'),
            actions: <Widget>[
              TextButton(
                child: const Text('Supper !'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // go to home
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          );
        });
  }
}
