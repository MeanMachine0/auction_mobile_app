// ignore_for_file: avoid_init_to_null

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
  bool itemsExpanded = false;
  bool endedItemsExpanded = false;
  bool itemsBidExpanded = false;
  bool endedItemsBidExpanded = false;

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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ExpansionPanelList(
                              expandedHeaderPadding: const EdgeInsets.all(0),
                              elevation: 0,
                              dividerColor: Colours.lightGray,
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  if (index == 0) {
                                    itemsExpanded = !itemsExpanded;
                                  }
                                  if (index == 1) {
                                    endedItemsExpanded = !endedItemsExpanded;
                                  }
                                  if (index == 2) {
                                    itemsBidExpanded = !itemsBidExpanded;
                                  }
                                  if (index == 3) {
                                    endedItemsBidExpanded =
                                        !endedItemsBidExpanded;
                                  }
                                });
                              },
                              children: [
                                ExpansionPanel(
                                  canTapOnHeader: true,
                                  backgroundColor: Colours.deepGray,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                      title: Text(
                                          'Active Listings (${_itemsModel!.length})',
                                          style: Elements.subHeader),
                                    );
                                  },
                                  body: _itemsModel!.isEmpty
                                      ? const Center(
                                          child: Text('No Listings to View.'))
                                      : ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _itemsModel!.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 2,
                                              ),
                                              child: GestureDetector(
                                                child: Card(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                        _itemsModel![index]
                                                                            .name,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: Elements
                                                                            .boldCardText),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                        '£${_itemsModel![index].price}, '
                                                                        '${_itemsModel![index].numBids} ${_itemsModel![index].numBids != 1 ? 'bids' : 'bid'}, '
                                                                        '${_itemsModel![index].condition != 'partsOnly' ? _itemsModel![index].condition : 'parts only'}, '
                                                                        'listed by ${widget.accountId ?? 'you'}',
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: Elements
                                                                            .cardText),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) => ItemDetail(
                                                              itemId:
                                                                  _itemsModel![
                                                                          index]
                                                                      .id)));
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                  isExpanded: itemsExpanded,
                                ),
                                ExpansionPanel(
                                  canTapOnHeader: true,
                                  backgroundColor: Colours.deepGray,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                      title: Text(
                                          'Inactive Listings (${_endedItemsModel!.length})',
                                          style: Elements.subHeader),
                                    );
                                  },
                                  body: _endedItemsModel!.isEmpty
                                      ? const Center(
                                          child: Text('No Listings to View.'))
                                      : ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _endedItemsModel!.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 2,
                                              ),
                                              child: GestureDetector(
                                                child: Card(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                        _endedItemsModel![index]
                                                                            .name,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: Elements
                                                                            .boldCardText),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                        '£${_endedItemsModel![index].price}, '
                                                                        '${_endedItemsModel![index].numBids} ${_endedItemsModel![index].numBids != 1 ? 'bids' : 'bid'}, '
                                                                        '${_endedItemsModel![index].condition != 'partsOnly' ? _endedItemsModel![index].condition : 'parts only'}, '
                                                                        'listed by ${widget.accountId ?? 'you'}',
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: Elements
                                                                            .cardText),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) => ItemDetail(
                                                              itemId:
                                                                  _endedItemsModel![
                                                                          index]
                                                                      .id)));
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                  isExpanded: endedItemsExpanded,
                                ),
                                if (widget.accountId == null)
                                  ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: Colours.deepGray,
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text(
                                            'Active Listings Bid on by Me (${_itemsBidOnByMe!.length})',
                                            style: Elements.subHeader),
                                      );
                                    },
                                    body: _itemsBidOnByMe!.isEmpty
                                        ? const Center(
                                            child: Text('No Listings to View.'))
                                        : ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _itemsBidOnByMe!.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 2,
                                                ),
                                                child: GestureDetector(
                                                  child: Card(
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(
                                                                          _itemsBidOnByMe![index]
                                                                              .name,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style:
                                                                              Elements.boldCardText),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 2),
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(
                                                                          '£${_itemsBidOnByMe![index].price}, '
                                                                          '${_itemsBidOnByMe![index].numBids} ${_itemsBidOnByMe![index].numBids != 1 ? 'bids' : 'bid'}, '
                                                                          '${_itemsBidOnByMe![index].condition != 'partsOnly' ? _itemsBidOnByMe![index].condition : 'parts only'}, '
                                                                          'listed by ${_itemsBidOnByMe![index].seller}',
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) => ItemDetail(
                                                                itemId:
                                                                    _itemsBidOnByMe![
                                                                            index]
                                                                        .id)));
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                    isExpanded: itemsBidExpanded,
                                  ),
                                if (widget.accountId == null)
                                  ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: Colours.deepGray,
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text(
                                            'Inactive Listings Bid on by Me (${_endedItemsBidOnByMe!.length})',
                                            style: Elements.subHeader),
                                      );
                                    },
                                    body: _endedItemsBidOnByMe!.isEmpty
                                        ? const Center(
                                            child: Text('No Listings to View.'))
                                        : ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                _endedItemsBidOnByMe!.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 2,
                                                ),
                                                child: GestureDetector(
                                                  child: Card(
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(
                                                                          _endedItemsBidOnByMe![index]
                                                                              .name,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style:
                                                                              Elements.boldCardText),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 2),
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(
                                                                          '£${_endedItemsBidOnByMe![index].price}, '
                                                                          '${_endedItemsBidOnByMe![index].numBids} ${_endedItemsBidOnByMe![index].numBids != 1 ? 'bids' : 'bid'}, '
                                                                          '${_endedItemsBidOnByMe![index].condition != 'partsOnly' ? _endedItemsBidOnByMe![index].condition : 'parts only'}, '
                                                                          'listed by ${_endedItemsBidOnByMe![index].seller}',
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) => ItemDetail(
                                                                itemId:
                                                                    _endedItemsBidOnByMe![
                                                                            index]
                                                                        .id)));
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                    isExpanded: endedItemsBidExpanded,
                                  ),
                              ]),
                        ],
                      ),
                    ),
                  ));
  }
}
