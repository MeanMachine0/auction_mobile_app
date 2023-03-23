import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:my_rest_api/elements.dart';
import 'package:my_rest_api/models/user_model.dart';
import 'package:my_rest_api/models/accounts_model.dart';
import 'package:my_rest_api/pages/home.dart';
import 'package:my_rest_api/services/api_service.dart';
import 'package:my_rest_api/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late List<String>? _IdToken = [];
  late int? userId = 0;
  late String? token = '';
  late String? username = '';
  late String? password = '';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    token = prefs.getString('token');
    username = prefs.getString('username');
    password = prefs.getString('password');
    if ((userId == null ||
            token == null ||
            username == null ||
            password == null) &
        !(usernameController.text.isEmpty || passwordController.text.isEmpty)) {
      _IdToken = (await ApiService()
          .getIdToken(usernameController.text, passwordController.text));
      try {
        await prefs.setInt('userId', int.parse(_IdToken![0]));
        await prefs.setString('token', _IdToken![1]);
        await prefs.setString('username', usernameController.text);
        await prefs.setString('password', passwordController.text);
        userId = prefs.getInt('userId');
        token = prefs.getString('token');
        username = prefs.getString('username');
        password = prefs.getString('password');
      } catch (e) {
        log(e.toString());
      }

      ApiService().login(usernameController.text, passwordController.text);
    } else if ((userId == null ||
            token == null ||
            username == null ||
            password == null) &
        (usernameController.text.isEmpty || passwordController.text.isEmpty)) {
    } else {
      ApiService().login(username!, password!);
    }

    setState(() {});
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userId == null ||
              token == null ||
              username == null ||
              password == null
          ? AppBar(title: const Text('Login'))
          : AppBar(title: const Text('Recently Sold Items')),
      body: userId == null ||
              token == null ||
              username == null ||
              password == null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
              child: Form(
                  child: Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        label: Text(
                          'Username',
                          style: TextStyle(color: Colours.lightGray),
                        ),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        label: Text(
                          'Password',
                          style: TextStyle(color: Colours.lightGray),
                        ),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () => _getData(),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Login'),
                        ))
                  ],
                ),
              )),
            )
          : const Home(),
    );
  }
}
