import 'package:flutter/material.dart';

import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginFormKey = GlobalKey<FormState>();
  late List<String>? _IdToken = [];
  late int? accountId = 0;
  late String? token = '';
  late String? username = '';
  bool invalidLogin = false;
  bool passVis = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = prefs.getInt('accountId');
    token = prefs.getString('token');
    username = prefs.getString('username');
    if ((token == null) &&
        !(usernameController.text.isEmpty || passwordController.text.isEmpty)) {
      ApiService apiService = ApiService();
      _IdToken = (await apiService.login(
          usernameController.text, passwordController.text));
      try {
        await prefs.setInt('accountId', int.parse(_IdToken![0]));
        await prefs.setString('token', _IdToken![1]);
        await prefs.setString('username', usernameController.text);
        await prefs.setString('password', passwordController.text);
        accountId = prefs.getInt('accountId');
        token = prefs.getString('token');
        username = prefs.getString('username');
        usernameController.text = '';
        passwordController.text = '';
        invalidLogin = false;
        if (token != null) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context, true);
        }
      } catch (e) {
        invalidLogin = true;
      }
    } else if ((token == null) &&
        (usernameController.text.isEmpty || passwordController.text.isEmpty)) {
      invalidLogin = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: token == null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                    key: loginFormKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: usernameController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (uN) {
                              if (uN == '') {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colours.red)),
                              errorStyle: TextStyle(color: Colours.red),
                              label: Text(
                                'Username',
                                style: TextStyle(color: Colours.lightGray),
                              ),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            obscureText: passVis,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (pW) {
                              if (pW == '') {
                                return 'Please enter a password.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colours.red),
                                ),
                                errorStyle: const TextStyle(color: Colours.red),
                                label: const Text(
                                  'Password',
                                  style: TextStyle(color: Colours.lightGray),
                                ),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: passVis
                                      ? const Icon(
                                          Icons.visibility_off_outlined)
                                      : const Icon(Icons.visibility_outlined),
                                  onPressed: () {
                                    passVis = !passVis;
                                    setState(() {});
                                  },
                                  splashColor: Colors.transparent,
                                )),
                          ),
                          SizedBox(height: invalidLogin ? 10 : 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: invalidLogin
                                  ? const [
                                      Text(
                                        'Invalid username and/or password.',
                                        style: TextStyle(color: Colours.red),
                                      )
                                    ]
                                  : const [Text('')]),
                          SizedBox(height: invalidLogin ? 10 : 15),
                          ElevatedButton(
                              onPressed: () {
                                if (loginFormKey.currentState!.validate()) {
                                  _getData();
                                }
                              },
                              child: const Text('Login',
                                  style: TextStyle(color: Colours.lightGray))),
                        ])))
            : Center(
                child: Text('Logged in as $username'),
              ));
  }
}
