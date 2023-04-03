import 'package:auction_mobile_app/pages/item_detail.dart';
import 'package:auction_mobile_app/pages/login.dart';
import 'package:flutter/material.dart';

import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyListings extends StatefulWidget {
  final int? accountId;
  const MyListings({Key? key, this.accountId}) : super(key: key);

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = widget.accountId ?? prefs.getInt('accountId');
    token = prefs.getString('token');
    username = prefs.getString('username');
    if (accountId != null) {
      _itemsModel = (await ApiService().getAccountItems(accountId!));
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
      appBar: AppBar(
          title: Text(widget.accountId == null
              ? 'My Listings'
              : '${widget.accountId}\'s Listings.'),
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
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const Login()));
                        },
                        child: const Text('Login',
                            style: TextStyle(color: Colours.lightGray))),
                  )
                ]),
      body: token != null
          ? _itemsModel == null || _itemsModel!.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colours.lightGray,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: DataTable(
                      border: TableBorder.all(
                          color: Colours.dimGray,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Bids')),
                        DataColumn(
                            label: Text(
                          'Top\nBidder',
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: _itemsModel!
                          .map(
                            (item) => DataRow(
                              cells: [
                                DataCell(
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              240)),
                                      child: Text(
                                        item.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                        ),
                                      ),
                                    ), onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          ItemDetail(itemId: item.id)));
                                }),
                                DataCell(Text(item.price)),
                                DataCell(Text(item.numBids.toString())),
                                DataCell(Text(item.buyerId.toString()),
                                    onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          MyListings(accountId: item.buyerId)));
                                })
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
          : const Center(
              child: Text('You must be logged in to view this page.'),
            ),
    );
  }
}
