import 'package:auction_mobile_app/pages/login.dart';
import 'package:flutter/material.dart';

import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/pages/item_detail.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Browse extends StatefulWidget {
  final bool _home;
  const Browse({Key? key, required bool home})
      : _home = home,
        super(key: key);

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  late List<ItemsModel>? _itemsModel = [];
  late List<ItemsModel>? items = [];
  late int? accountId = 0;
  late String? token = '';
  late String? username = '';
  late String? password = '';
  int selectedIndex = 0;

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
    _itemsModel = (await ApiService().getItems(widget._home, widget._home));
    items = _itemsModel;
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
          scrolledUnderElevation: 0,
          title: const Text('Active Items'),
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
      body: _itemsModel == null || _itemsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colours.lightGray,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    height: 70,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 11,
                        itemBuilder: (content, index) {
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (states) => selectedIndex == index
                                              ? Colours.deepGray
                                              : Colours.darkGray),
                                ),
                                child: Text(
                                  Lists.categories[index],
                                  style:
                                      const TextStyle(color: Colours.lightGray),
                                ),
                                onPressed: () {
                                  items = index == 0
                                      ? _itemsModel!
                                      : _itemsModel!
                                          .where((item) =>
                                              item.category ==
                                              Dicts.categories[
                                                  Lists.categories[index]])
                                          .toList();
                                  selectedIndex = index;
                                  setState(() {});
                                },
                              ));
                        }),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: items!.isEmpty
                      ? const Center(
                          child: Text('No Listings to View in this category.'))
                      : ListView.builder(
                          itemCount: items!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
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
                                                child: Text(items![index].name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start,
                                                    style:
                                                        Elements.boldCardText),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    '£${items![index].price}, '
                                                    '${items![index].numBids} ${items![index].numBids != 1 ? 'bids' : 'bid'}, '
                                                    '${items![index].condition != 'partsOnly' ? items![index].condition : 'parts only'}, '
                                                    'listed by ${accountId == items![index].seller ? 'you' : items![index].seller}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                      builder: (_) => ItemDetail(
                                          itemId: items![index].id)));
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
