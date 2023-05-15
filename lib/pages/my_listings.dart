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
  List<bool> expanded = [false, false, false, false];
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    accountId = prefs.getInt('accountId');
    myAccountId = accountId;
    accountId ?? widget.accountId;
    username = prefs.getString('username');
    ApiService apiService = ApiService();
    if (widget.accountId != null || accountId != null) {
      _itemsModel = (await apiService.getAccountItems(
        (widget.accountId ?? accountId)!,
        token,
        false,
      ))
          .cast<ItemModel>();
      _endedItemsModel = (await apiService.getAccountItems(
        (widget.accountId ?? accountId)!,
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

  @override
  Widget build(BuildContext context) {
    double usableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.accountId == null
              ? 'My Listings'
              : '${widget._username}\'${widget._username!.substring(widget._username!.length - 1) == 's' ? '' : 's'} Listings'),
          actions: token != null
              ? [
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.resolveWith<double?>(
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : token == null && widget.accountId == null
              ? const Center(
                  child: Text('You must be logged in to view this page.'),
                )
              : Column(
                  children: [
                    ExpansionPanelList(
                        expandedHeaderPadding: const EdgeInsets.all(0),
                        elevation: 0,
                        dividerColor: Colours.lightGray,
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            for (int i = 0; i < 4; i++) {
                              if (i == index) {
                                expanded[i] = !expanded[i];
                              } else {
                                expanded[i] = false;
                              }
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
                                    overflow: TextOverflow.ellipsis,
                                    style: Elements.subHeader),
                              );
                            },
                            body: _itemsModel!.isEmpty
                                ? const Center(
                                    child: Text('No Listings to View.'))
                                : SizedBox(
                                    height: widget.accountId == null
                                        ? usableHeight - 385
                                        : usableHeight - 190,
                                    child: ItemCardList(
                                      itemsModel: _itemsModel!,
                                      accountId: myAccountId ?? 0,
                                    ),
                                  ),
                            isExpanded: expanded[0],
                          ),
                          ExpansionPanel(
                            canTapOnHeader: true,
                            backgroundColor: Colours.deepGray,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Text(
                                    'Inactive Listings (${_endedItemsModel!.length})',
                                    overflow: TextOverflow.ellipsis,
                                    style: Elements.subHeader),
                              );
                            },
                            body: _endedItemsModel!.isEmpty
                                ? const Center(
                                    child: Text('No Listings to View.'))
                                : SizedBox(
                                    height: widget.accountId == null
                                        ? usableHeight - 400
                                        : usableHeight - 190,
                                    child: ItemCardList(
                                      itemsModel: _endedItemsModel!,
                                      accountId: myAccountId ?? 0,
                                    ),
                                  ),
                            isExpanded: expanded[1],
                          ),
                          if (widget.accountId == null)
                            ExpansionPanel(
                              canTapOnHeader: true,
                              backgroundColor: Colours.deepGray,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                      'Active Listings Bid on by Me (${_itemsBidOnByMe!.length})',
                                      overflow: TextOverflow.ellipsis,
                                      style: Elements.subHeader),
                                );
                              },
                              body: _itemsBidOnByMe!.isEmpty
                                  ? const Center(
                                      child: Text('No Listings to View.'))
                                  : SizedBox(
                                      height: usableHeight - 400,
                                      child: ItemCardList(
                                        itemsModel: _itemsBidOnByMe!,
                                        accountId: myAccountId ?? 0,
                                      ),
                                    ),
                              isExpanded: expanded[2],
                            ),
                          if (widget.accountId == null)
                            ExpansionPanel(
                              canTapOnHeader: true,
                              backgroundColor: Colours.deepGray,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                      'Inactive Listings Bid on by Me (${_endedItemsBidOnByMe!.length})',
                                      overflow: TextOverflow.ellipsis,
                                      style: Elements.subHeader),
                                );
                              },
                              body: _endedItemsBidOnByMe!.isEmpty
                                  ? const Center(
                                      child: Text('No Listings to View.'))
                                  : SizedBox(
                                      height: usableHeight - 385,
                                      child: ItemCardList(
                                        itemsModel: _endedItemsBidOnByMe!,
                                        accountId: myAccountId ?? 0,
                                      ),
                                    ),
                              isExpanded: expanded[3],
                            ),
                        ]),
                  ],
                ),
    );
  }
}
