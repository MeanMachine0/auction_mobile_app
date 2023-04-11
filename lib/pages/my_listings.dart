// ignore_for_file: avoid_init_to_null

import 'package:auction_mobile_app/elements.dart';
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
  late List<ItemsModel>? _endedItemsModel = [];
  late List<ItemsModel>? _itemsBidOnByMe = [];
  late List<ItemsModel>? _endedItemsBidOnByMe = [];
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
      _itemsModel = (await apiService.getAccountItems(
        accountId!,
        token,
        false,
      ))
          .cast<ItemsModel>();
      _endedItemsModel = (await apiService.getAccountItems(
        accountId!,
        token,
        true,
      ))
          .cast<ItemsModel>();
      if (widget.accountId == null) {
        seller = true;
        if (token != null) {
          _itemsBidOnByMe = (await apiService.getItemsBidOnByMe(
            accountId!,
            token!,
            false,
          ))
              .cast<ItemsModel>();
          _endedItemsBidOnByMe = (await apiService.getItemsBidOnByMe(
            accountId!,
            token!,
            true,
          ))
              .cast<ItemsModel>();
        }
      }
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
                          onPressed: () {
                            _logout();
                          },
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
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const Login()));
                            if (result == true) {
                              _getData();
                            }
                          },
                          child: const Text('Login',
                              style: TextStyle(color: Colours.lightGray))),
                    )
                  ]),
        body: token == null && widget.accountId == null
            ? const Center(
                child: Text('You must be logged in to view this page.'),
              )
            : (_itemsModel == null || _itemsModel!.isEmpty) &&
                    (_endedItemsModel == null || _endedItemsModel!.isEmpty) &&
                    (_itemsBidOnByMe == null || _itemsBidOnByMe!.isEmpty) &&
                    (_endedItemsBidOnByMe == null ||
                        _endedItemsBidOnByMe!.isEmpty)
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colours.lightGray,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Center(
                              child: Text('Active Listings',
                                  style: Elements.cardHeader)),
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 40),
                              child: _itemsModel!.isEmpty
                                  ? const Center(
                                      child: Text(
                                          'There are no listings to view.'))
                                  : DataTable(
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
                                                                280)),
                                                    child: Text(
                                                      item.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationStyle:
                                                            TextDecorationStyle
                                                                .solid,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    await Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (_) =>
                                                                ItemDetail(
                                                                    itemId: item
                                                                        .id)));
                                                    _getData();
                                                  },
                                                ),
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
                                                                : item.buyer !=
                                                                        null
                                                                    ? item.buyer
                                                                        .toString()
                                                                    : seller
                                                                        ? ''
                                                                        : 'Not You',
                                                            style: item.seller ==
                                                                        myAccountId &&
                                                                    item.buyer !=
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
                                                    onTap:
                                                        item.buyer ==
                                                                myAccountId
                                                            ? null
                                                            : item.seller !=
                                                                    myAccountId
                                                                ? null
                                                                : item.buyer !=
                                                                        null
                                                                    ? () async {
                                                                        await Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                MyListings(accountId: item.buyer)));
                                                                        _getData();
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
                                  minWidth:
                                      MediaQuery.of(context).size.width - 40),
                              child: _endedItemsModel!.isEmpty
                                  ? const Center(
                                      child: Text(
                                          'There are no listings to view.'))
                                  : DataTable(
                                      border: TableBorder.all(
                                        color: Colours.deepBlue,
                                        width: 0.75,
                                      ),
                                      columns: [
                                        const DataColumn(label: Text('Name')),
                                        const DataColumn(label: Text('Price')),
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
                                                                280)),
                                                    child: Text(
                                                      endedItem.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationStyle:
                                                            TextDecorationStyle
                                                                .solid,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                EndedItemDetail(
                                                                    endedItemId:
                                                                        endedItem
                                                                            .id)));
                                                    _getData();
                                                  },
                                                ),
                                                DataCell(Text(
                                                    '£${endedItem.price}')),
                                                DataCell(Text(Dicts
                                                    .toYesNo[endedItem.sold]!)),
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
                                                                : endedItem.buyer !=
                                                                        null
                                                                    ? endedItem
                                                                        .buyer
                                                                        .toString()
                                                                    : seller
                                                                        ? ''
                                                                        : 'Not You',
                                                            style: endedItem.seller ==
                                                                        myAccountId &&
                                                                    endedItem
                                                                            .buyer !=
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
                                                    onTap: endedItem.buyer ==
                                                            myAccountId
                                                        ? null
                                                        : endedItem.seller !=
                                                                myAccountId
                                                            ? null
                                                            : endedItem.buyer !=
                                                                    null
                                                                ? () async {
                                                                    await Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                MyListings(accountId: endedItem.buyer)));
                                                                    _getData();
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
                          SizedBox(height: widget.accountId == null ? 40 : 0),
                          Center(
                              child: widget.accountId == null
                                  ? const Text('Active Listings Bid on by Me',
                                      style: Elements.cardHeader)
                                  : null),
                          SizedBox(height: widget.accountId == null ? 20 : 0),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                                constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.width - 40),
                                child: widget.accountId != null
                                    ? null
                                    : _itemsBidOnByMe!.isEmpty
                                        ? const Center(
                                            child: Text(
                                                'There are no listings to view.'))
                                        : DataTable(
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
                                              DataColumn(label: Text('Seller')),
                                            ],
                                            rows: _itemsBidOnByMe!
                                                .map(
                                                  (item) => DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Container(
                                                          constraints: BoxConstraints(
                                                              maxWidth: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  280)),
                                                          child: Text(
                                                            item.name,
                                                            overflow:
                                                                TextOverflow
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
                                                        ),
                                                        onTap: () async {
                                                          await Navigator.of(
                                                                  context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      ItemDetail(
                                                                          itemId:
                                                                              item.id)));
                                                          _getData();
                                                        },
                                                      ),
                                                      DataCell(Text(
                                                          '£${item.price}')),
                                                      DataCell(Text(item.numBids
                                                          .toString())),
                                                      DataCell(
                                                        Text(
                                                          item.buyer != null
                                                              ? 'You'
                                                              : 'Not You',
                                                        ),
                                                      ),
                                                      DataCell(
                                                          Text(
                                                            item.seller
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              decorationStyle:
                                                                  TextDecorationStyle
                                                                      .solid,
                                                            ),
                                                          ), onTap: () async {
                                                        await Navigator.of(
                                                                context)
                                                            .push(
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        MyListings(
                                                                          accountId:
                                                                              item.seller,
                                                                        )));
                                                        _getData();
                                                      }),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                          )),
                          ),
                          SizedBox(height: widget.accountId == null ? 40 : 0),
                          Center(
                              child: widget.accountId == null
                                  ? const Text('Inactive Listings Bid on by Me',
                                      style: Elements.cardHeader)
                                  : null),
                          SizedBox(height: widget.accountId == null ? 20 : 0),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                                constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.width - 40),
                                child: widget.accountId != null
                                    ? null
                                    : _endedItemsBidOnByMe!.isEmpty
                                        ? const Center(
                                            child: Text(
                                                'There are no listings to view.'))
                                        : DataTable(
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
                                                'Buyer',
                                                textAlign: TextAlign.center,
                                              )),
                                              DataColumn(label: Text('Seller')),
                                            ],
                                            rows: _endedItemsBidOnByMe!
                                                .map(
                                                  (endedItem) => DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Container(
                                                          constraints: BoxConstraints(
                                                              maxWidth: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  280)),
                                                          child: Text(
                                                            endedItem.name,
                                                            overflow:
                                                                TextOverflow
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
                                                        ),
                                                        onTap: () async {
                                                          await Navigator.of(
                                                                  context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      EndedItemDetail(
                                                                          endedItemId:
                                                                              endedItem.id)));
                                                          _getData();
                                                        },
                                                      ),
                                                      DataCell(Text(
                                                          '£${endedItem.price}')),
                                                      DataCell(Text(endedItem
                                                          .numBids
                                                          .toString())),
                                                      DataCell(
                                                        Text(
                                                          endedItem.buyer !=
                                                                  null
                                                              ? 'You'
                                                              : 'Not You',
                                                        ),
                                                      ),
                                                      DataCell(
                                                          Text(
                                                            endedItem.seller
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              decorationStyle:
                                                                  TextDecorationStyle
                                                                      .solid,
                                                            ),
                                                          ), onTap: () async {
                                                        await Navigator.of(
                                                                context)
                                                            .push(
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        MyListings(
                                                                          accountId:
                                                                              endedItem.seller,
                                                                        )));
                                                        _getData();
                                                      }),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                          )),
                          ),
                        ],
                      ),
                    ),
                  ));
  }
}
