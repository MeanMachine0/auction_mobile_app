// ignore_for_file: avoid_init_to_null

import 'package:auction_mobile_app/elements.dart';
import 'package:auction_mobile_app/models/ended_items_model.dart';
import 'package:auction_mobile_app/pages/ended_item_detail.dart';
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
  late List<EndedItemsModel>? _endedItemsModel = [];
  late int? accountId = null;
  late int? myAccountId = null;
  late String? token = null;
  late String? username = null;
  bool seller = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = widget.accountId ?? prefs.getInt('accountId');
    myAccountId = prefs.getInt('accountId');
    token = prefs.getString('token');
    username = prefs.getString('username');
    if (accountId != null) {
      ApiService apiService = ApiService();
      _itemsModel = await apiService.getAccountItems(accountId!, token);
      _endedItemsModel =
          await apiService.getAccountEndedItems(accountId!, token);
      if (widget.accountId == null) {
        seller = true;
      }
      setState(() {});
    }
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
                : '${widget.accountId}\'s Listings'),
            actions: token != null
                ? [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            elevation:
                                MaterialStateProperty.resolveWith<double?>(
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
                            elevation:
                                MaterialStateProperty.resolveWith<double?>(
                                    (_) => 0),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const Login()));
                          },
                          child: const Text('Login',
                              style: TextStyle(color: Colours.lightGray))),
                    )
                  ]),
        body: token == null && widget.accountId == null
            ? const Center(
                child: Text('You must be logged in to view this page.'),
              )
            : _itemsModel == null || _itemsModel!.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colours.lightGray,
                    ),
                  )
                : Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _itemsModel![0].endDateTime == DateTime(404)
                              ? const [Text('There are no listings to view.')]
                              : [
                                  const Center(
                                      child: Text('Active Listings',
                                          style: Elements.cardHeader)),
                                  const SizedBox(height: 20),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40),
                                      child: DataTable(
                                        border: TableBorder.all(
                                          color: Colours.deepBlue,
                                          width: 0.75,
                                        ),
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
                                                            maxWidth:
                                                                (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    240)),
                                                        child: Text(
                                                          item.name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style:
                                                              const TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                          ),
                                                        ),
                                                      ), onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                ItemDetail(
                                                                    itemId: item
                                                                        .id)));
                                                  }),
                                                  DataCell(
                                                      Text('£${item.price}')),
                                                  DataCell(Text(
                                                      item.numBids.toString())),
                                                  DataCell(
                                                      FutureBuilder(
                                                        future: ApiService()
                                                            .amITheBuyer(
                                                          item.id,
                                                          token,
                                                          false,
                                                        ),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<bool>
                                                                snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Text(
                                                                'Loading...');
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          } else {
                                                            return Text(
                                                              snapshot.data ==
                                                                      true
                                                                  ? 'You'
                                                                  : item.buyerId !=
                                                                          null
                                                                      ? item
                                                                          .buyerId
                                                                          .toString()
                                                                      : seller
                                                                          ? ''
                                                                          : 'Not You',
                                                              style: item.sellerId ==
                                                                          myAccountId &&
                                                                      item.buyerId !=
                                                                          null
                                                                  ? const TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      decorationStyle:
                                                                          TextDecorationStyle
                                                                              .solid,
                                                                    )
                                                                  : null,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                      onTap: item.buyerId ==
                                                              myAccountId
                                                          ? null
                                                          : item.sellerId !=
                                                                  myAccountId
                                                              ? null
                                                              : item.buyerId !=
                                                                      null
                                                                  ? () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                              MaterialPageRoute(builder: (_) => MyListings(accountId: item.buyerId)));
                                                                    }
                                                                  : null)
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  const Center(
                                      child: Text('Inactive Listings',
                                          style: Elements.cardHeader)),
                                  const SizedBox(height: 20),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40),
                                      child: DataTable(
                                        border: TableBorder.all(
                                          color: Colours.deepBlue,
                                          width: 0.75,
                                        ),
                                        columns: [
                                          const DataColumn(label: Text('Name')),
                                          const DataColumn(
                                              label: Text('Price')),
                                          const DataColumn(label: Text('Sold')),
                                          const DataColumn(
                                            label: Text(
                                              'Buyer',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          if (seller)
                                            const DataColumn(
                                                label: Text('Destination')),
                                        ],
                                        rows: _endedItemsModel!
                                            .map(
                                              (endedItem) => DataRow(
                                                cells: [
                                                  DataCell(
                                                      Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth:
                                                                (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    240)),
                                                        child: Text(
                                                          endedItem.name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style:
                                                              const TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                          ),
                                                        ),
                                                      ), onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                EndedItemDetail(
                                                                    endedItemId:
                                                                        endedItem
                                                                            .id)));
                                                  }),
                                                  DataCell(Text(
                                                      '£${endedItem.price}')),
                                                  DataCell(Text(Dicts.toYesNo[
                                                      endedItem.sold]!)),
                                                  DataCell(
                                                      FutureBuilder(
                                                        future: ApiService()
                                                            .amITheBuyer(
                                                          endedItem.id,
                                                          token,
                                                          true,
                                                        ),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<bool>
                                                                snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Text(
                                                                'Loading...');
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          } else {
                                                            return Text(
                                                              snapshot.data ==
                                                                      true
                                                                  ? 'You'
                                                                  : endedItem.buyerId !=
                                                                          null
                                                                      ? endedItem
                                                                          .buyerId
                                                                          .toString()
                                                                      : seller
                                                                          ? ''
                                                                          : 'Not You',
                                                              style: endedItem.sellerId ==
                                                                          myAccountId &&
                                                                      endedItem
                                                                              .buyerId !=
                                                                          null
                                                                  ? const TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      decorationStyle:
                                                                          TextDecorationStyle
                                                                              .solid,
                                                                    )
                                                                  : null,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                      onTap: endedItem
                                                                  .buyerId ==
                                                              myAccountId
                                                          ? null
                                                          : endedItem.sellerId !=
                                                                  myAccountId
                                                              ? null
                                                              : endedItem.buyerId !=
                                                                      null
                                                                  ? () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                              MaterialPageRoute(builder: (_) => MyListings(accountId: endedItem.buyerId)));
                                                                    }
                                                                  : null),
                                                  if (seller)
                                                    DataCell(Text(endedItem
                                                            .destinationAddress ??
                                                        '')),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ));
  }
}
