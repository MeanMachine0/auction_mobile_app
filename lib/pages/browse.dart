import 'package:auction_mobile_app/pages/login.dart';
import 'package:flutter/material.dart';

import 'package:auction_mobile_app/models/item_model.dart';
import 'package:auction_mobile_app/pages/item_detail.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/item_card_list.dart';

class Browse extends StatefulWidget {
  final bool _home;
  const Browse({Key? key, required bool home})
      : _home = home,
        super(key: key);

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  late List<ItemModel>? _itemsModel = [];
  late String? token = '';
  late int? accountId = 0;
  late String? username = '';
  bool searchBool = false;
  String search = '';
  int categoryIndex = 0;
  int conditionIndex = 0;
  String sortBy = 'Price';
  bool ascending = true;
  String? downloadURL;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? outbiddedId = prefs.getInt('outbiddedId');
    if (outbiddedId != null) {
      prefs.remove('outbiddedId');
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ItemDetail(itemId: outbiddedId)));
    }
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    accountId = prefs.getInt('accountId');
    username = prefs.getString('username');
    String category =
        Dicts.categories[Lists.categories[categoryIndex]] ?? 'all';
    String condition =
        Dicts.conditions[Lists.conditions[conditionIndex]] ?? 'all';
    // ignore: no_leading_underscores_for_local_identifiers
    String _sortBy = Dicts.sorters[sortBy]!;
    _itemsModel = (await ApiService().getItems(widget._home, widget._home,
        searchBool, search, category, condition, _sortBy, ascending));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0,
          title: !widget._home
              ? Text('Active Items (${_itemsModel!.length})')
              : Text('Recently Sold Items (${_itemsModel!.length})'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Lists.categories.length,
                  itemBuilder: (content, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) => categoryIndex == index
                                        ? Colours.deepGray
                                        : Colours.darkGray),
                          ),
                          child: Text(
                            Lists.categories[index],
                            style: const TextStyle(color: Colours.lightGray),
                          ),
                          onPressed: () {
                            categoryIndex = index;
                            _getData();
                          },
                        ));
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Lists.conditions.length,
                  itemBuilder: (content, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(3, 0, 3, 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) => conditionIndex == index
                                        ? Colours.deepGray
                                        : Colours.darkGray),
                          ),
                          child: Text(
                            Lists.conditions[index],
                            style: const TextStyle(
                              color: Colours.lightGray,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            conditionIndex = index;
                            _getData();
                          },
                        ));
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      onSubmitted: (string) {
                        searchBool = true;
                        search = string;
                        _getData();
                      },
                      decoration: const InputDecoration(
                        label: Text('Search'),
                        suffixIcon: Icon(Icons.search),
                        iconColor: Colours.lightGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                DropdownButton(
                  value: sortBy,
                  items: Lists.sorters
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    sortBy = value!;
                    _getData();
                  },
                ),
                const SizedBox(width: 2),
                GestureDetector(
                    onTap: (() {
                      ascending = !ascending;
                      _getData();
                    }),
                    child: Icon(
                      ascending ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colours.lightGray,
                    ))
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _itemsModel!.isEmpty
                    ? const Center(
                        child: Text(
                            'No Listings to View in this Category-Condition.'))
                    : ItemCardList(
                        itemsModel: _itemsModel!, accountId: accountId ?? 0),
          ),
        ],
      ),
    );
  }
}
