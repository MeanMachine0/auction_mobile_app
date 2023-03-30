import 'package:auction_mobile_app/pages/item_detail.dart';
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
        title: const Text('My Listings'),
      ),
      body: _itemsModel == null || _itemsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : token != null
              ? _itemsModel == null || _itemsModel!.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: DataTable(
                          border: TableBorder.all(
                              color: Colours.dimGray,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Bids')),
                            DataColumn(label: Text('Seller')),
                          ],
                          rows: _itemsModel!
                              .where((item) => item.sellerId == accountId)
                              .map(
                                (item) => DataRow(
                                  cells: [
                                    DataCell(
                                        SizedBox(
                                          width: 200,
                                          child: Text(item.name,
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                              )),
                                        ), onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ItemDetail(itemId: item.id)));
                                    }),
                                    DataCell(Text(item.price)),
                                    DataCell(Text(item.numBids.toString())),
                                    DataCell(Text(item.sellerId.toString())),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
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
