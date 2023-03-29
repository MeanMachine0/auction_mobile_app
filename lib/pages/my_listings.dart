import 'package:auction_mobile_app/pages/login.dart';
import 'package:flutter/material.dart';

import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyListings extends StatefulWidget {
  const MyListings({Key? key}) : super(key: key);

  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  late List<ItemsModel>? _itemsModel = [];
  late int? accountId = 0;
  late String? token = '';
  late String? username = '';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _itemsModel = (await ApiService().getItems());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = prefs.getInt('accountId');
    token = prefs.getString('token');
    username = prefs.getString('username');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bids'),
      ),
      body: _itemsModel == null || _itemsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : token != null
              ? ListView.builder(
                  itemCount: _itemsModel!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(_itemsModel![index].price.toString()),
                              Text(_itemsModel![index].condition.toString()),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(_itemsModel![index].description),
                              Text(_itemsModel![index].sellerId.toString()),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const Login()));
                    },
                    child: const Text('Login'),
                  ),
                ),
    );
  }
}
