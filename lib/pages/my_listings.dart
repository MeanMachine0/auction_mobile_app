// ignore_for_file: avoid_init_to_null

import 'package:auction_mobile_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:auction_mobile_app/models/item_model.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/item_card_list.dart';

class MyListings extends StatefulWidget {
  const MyListings({Key? key, this.accountId, String? username})
      : _username = username,
        super(key: key);
  final int? accountId;
  final String? _username;
  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  late List<ItemModel>? _itemsModel = [];
  late List<ItemModel>? _endedItemsModel = [];
  late List<ItemModel>? _itemsBidOnByMe = [];
  late List<ItemModel>? _endedItemsBidOnByMe = [];
  late String? token = null;
  late int? accountId = null;
  late int? myAccountId = null;
  late String? username = null;
  bool seller = false;
  bool itemsExpanded = false;
  bool endedItemsExpanded = false;
  bool itemsBidExpanded = false;
  bool endedItemsBidExpanded = false;
  String? downloadURL;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() {
      isLoading = true;
    });
    getCredentials();
    if (accountId != null) {
      ApiService apiService = ApiService();
      _itemsModel = (await apiService.getAccountItems(
        accountId!,
        token,
        false,
      ))
          .cast<ItemModel>();
      _endedItemsModel = (await apiService.getAccountItems(
        accountId!,
        token,
        true,
      ))
          .cast<ItemModel>();
      if (widget.accountId == null) {
        seller = true;
        if (token != null) {
          _itemsBidOnByMe = (await apiService.getItemsBidOnByMe(
            accountId!,
            token!,
            false,
          ))
              .cast<ItemModel>();
          _endedItemsBidOnByMe = (await apiService.getItemsBidOnByMe(
            accountId!,
            token!,
            true,
          ))
              .cast<ItemModel>();
        }
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    accountId = prefs.getInt('accountId');
    username = prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.accountId == null
                ? 'My Listings'
                : '${widget._username}\'s Listings'),
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
                            if (token != null) {
                              ApiService().logout(token);
                              _getData();
                            }
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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : token == null && widget.accountId == null
                ? const Center(
                    child: Text('You must be logged in to view this page.'),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                      : ItemCardList(
                                          itemsModel: _itemsModel!,
                                          accountId: myAccountId ?? 0,
                                          scrollable: false,
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
                                      : ItemCardList(
                                          itemsModel: _endedItemsModel!,
                                          accountId: myAccountId ?? 0,
                                          scrollable: false,
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
                                        : ItemCardList(
                                            itemsModel: _itemsBidOnByMe!,
                                            accountId: myAccountId ?? 0,
                                            scrollable: false,
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
                                        : ItemCardList(
                                            itemsModel: _endedItemsBidOnByMe!,
                                            accountId: myAccountId ?? 0,
                                            scrollable: false,
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
