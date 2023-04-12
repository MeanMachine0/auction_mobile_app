import 'package:auction_mobile_app/elements.dart';
import 'package:auction_mobile_app/pages/login.dart';
import 'package:flutter/material.dart';

import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/pages/ended_item_detail.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<ItemsModel>? _EndedItemsModel = [];
  late List<String>? _IdToken = [];
  late int? accountId = 0;
  late String? token = '';
  late String? username = '';
  late String? password = '';

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
    password = prefs.getString('password');
    ApiService apiService = ApiService();
    _EndedItemsModel = await apiService.getItems(true, true);
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
      appBar: AppBar(
          title: const Text('Recently Sold Items'),
          actions: token != null
              ? [
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.resolveWith<double?>(
                              (_) => 0),
                        ),
                        onPressed: () => _logout(),
                        child: const Text('Logout',
                            style: TextStyle(color: Colours.lightGray))),
                  ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.resolveWith<double?>(
                              (_) => 0),
                        ),
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const Login()));
                          if (result == true) {
                            _getData();
                          }
                        },
                        child: const Text('Login',
                            style: TextStyle(color: Colours.lightGray))),
                  )
                ]),
      body: _EndedItemsModel == null || _EndedItemsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colours.lightGray,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                itemCount: _EndedItemsModel!.length,
                itemBuilder: (context, index) {
                  ItemsModel item = _EndedItemsModel!.toList()[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                (states) => Colours.darkGray),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(_EndedItemsModel![index].name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: Elements.boldCardText),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                          '£${_EndedItemsModel![index].price}, '
                                          '${_EndedItemsModel![index].numBids} ${_EndedItemsModel![index].numBids != 1 ? 'bids' : 'bid'}, '
                                          '${_EndedItemsModel![index].condition != 'partsOnly' ? _EndedItemsModel![index].condition : 'parts only'}, '
                                          'listed by ${accountId == _EndedItemsModel![index].seller ? 'you' : _EndedItemsModel![index].seller}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: Elements.cardText),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => EndedItemDetail(
                                endedItemId: _EndedItemsModel![index].id)));
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
