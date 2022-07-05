/// Connection page to the api
/// we send the login and the password to the api
/// and we get the token

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
	const LoginPage({Key key}) : super(key: key);

	@override
	State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	String _login = '';
	String _password = '';

	Widget _buildLogin() {
		return TextFormField(
			keyboardType: TextInputType.emailAddress,
			decoration: const InputDecoration(
				labelText: 'Login',
				border: OutlineInputBorder(),
			),
				onChanged:
				(String value) {
					_login = value;
				},
				validator: (String value) {
					if (value == null || value.isEmpty) {
						return 'Please enter your login';
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
			onChanged:
			(String value) {
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
				  	child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
				  		children: <Widget>[
				  			_buildLogin(),
							const SizedBox(height: 16.0),
				  			_buildPassword(),
				  			const SizedBox(height: 16.0),
				  			
				  			ElevatedButton(
				  				child: const Text('Login'),
				  				onPressed: () async {
										if( _formKey.currentContext == null || !_formKey.currentState.validate()) {
											return;
										}

										Uri url = Uri.parse('http://10.0.2.2:3000/api/auth/login');
										Object data = {
											"email": _login,
											"password": _password,
										};
										try {
											http.Response response = await http.post(
												url,
												headers: <String, String>{
													'Content-Type': 'application/json; charset=UTF-8',
												},
												body: jsonEncode(data)
											);

											if(response.statusCode != 201) {
												String msg = 'Unknown error';
												if(response.reasonPhrase != '') {
													msg = response.reasonPhrase;
												}

												_showError(context, msg);
											} else {
												print('Connected');
											}
											print('Response status: ${response.statusCode}');
											print('Response body: ${response.body}');
										} catch(e) {
											_showError(context, e.toString());
										}
				  				},
				  			),
				  		],
				  	),
				  ),
				)
			),
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
}
