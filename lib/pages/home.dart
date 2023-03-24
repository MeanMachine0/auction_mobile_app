import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:my_rest_api/models/ended_items_model.dart';
import 'package:my_rest_api/pages/ended_item_detail.dart';
import 'package:my_rest_api/services/api_service.dart';
import 'package:my_rest_api/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<EndedItemsModel>? _EndedItemsModel = [];
  late List<String>? _IdToken = [];
  late int? userId = 0;
  late String? token = '';
  late String? username = '';
  late String? password = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      _EndedItemsModel = (await ApiService().getEndedItems());
      usernameController.text = '';
      passwordController.text = '';
    } else if ((userId == null ||
            token == null ||
            username == null ||
            password == null) &
        (usernameController.text.isEmpty || passwordController.text.isEmpty)) {
    } else {
      ApiService().login(username!, password!);
      _EndedItemsModel = (await ApiService().getEndedItems());
      usernameController.text = '';
      passwordController.text = '';
    }
    setState(() {});
  }

  void _logout() {
    if (token != null) {
      ApiService().logout(token);
      _getData();
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: () => _getData(), child: const Text('Login'))
                ],
              )),
            )
          : _EndedItemsModel == null || _EndedItemsModel!.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 600,
                        child: ListView.builder(
                          itemCount: _EndedItemsModel!
                              .where((item) => item.sold)
                              .length,
                          itemBuilder: (context, index) {
                            EndedItemsModel item = _EndedItemsModel!
                                .where((item) => item.sold)
                                .toList()[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => EndedItemDetail(
                                          endedItemId: item.id)));
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                                '${item.name} - £${item.salePrice.toString()}'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () => _logout(), child: const Text('Logout'))
                  ],
                ),
    );
  }
}
