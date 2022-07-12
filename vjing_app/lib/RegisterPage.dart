///
/// Registration page to the api
///

// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _repeatPassword = '';
  String _lastName = '';
  String _firstName = '';
  String _username = '';

  Widget _buildEmail() {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          _email = value;
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

  Widget _buildPasswordConfirmation() {
    return TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password confirmation',
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          _repeatPassword = value;
        },
        validator: (String value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _password) {
            return 'Passwords do not match';
          }
          return null;
        });
  }

  Widget _buildLastname() {
    return TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          labelText: 'Lastname',
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          _lastName = value;
        },
        validator: (String value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your lastname';
          }
          return null;
        });
  }

  Widget _buildFirstname() {
    return TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          labelText: 'Firstname',
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          _firstName = value;
        },
        validator: (String value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your firstname';
          }
          return null;
        });
  }

  Widget _buildUsername() {
    return TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          _username = value;
        },
        validator: (String value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your username';
          }
          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Wrap(
                  runSpacing: 16.0,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 10.0),
                        child: Column(
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
                        )),
                    _buildEmail(),
                    _buildPassword(),
                    _buildPasswordConfirmation(),
                    _buildLastname(),
                    _buildFirstname(),
                    _buildUsername(),
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
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentContext == null ||
                                !_formKey.currentState.validate()) {
                              return;
                            }

                            Uri url = Uri.parse(
                                'http://164.92.201.208:3000/api/auth/register');
                            Object data = {
                              "email": _email,
                              "password": _password,
                              "repeat_password": _repeatPassword,
                              "last_name": _lastName,
                              "first_name": _firstName,
                              "username": _username
                            };
                            try {
                              http.Response response = await http.post(url,
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(data));

                              if (response.statusCode != 201) {
                                Map res = json.decode(response.body);
                                String msg = 'Unknown error';
                                if (res.containsKey('message')) {
                                  msg = res['message'];
                                } else if (response.reasonPhrase != '') {
                                  msg = response.reasonPhrase;
                                }

                                _showError(context, msg);
                              } else {
                                print('Registration success');
                                _showSuccess(context);
                              }
                            } catch (e) {
                              _showError(context, e.toString());
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
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
            content: Text('Incription réussie'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cool !'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // go to home
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
        });
  }
}
