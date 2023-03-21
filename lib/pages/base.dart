import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_rest_api/colours.dart';
import 'package:my_rest_api/pages/home.dart';
import 'package:my_rest_api/pages/item_detail.dart';
import 'package:my_rest_api/pages/my_listings.dart';
import 'package:my_rest_api/pages/browse.dart';
import 'package:my_rest_api/pages/list_an_item.dart';

class Base extends StatefulWidget {
  const Base({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _selectedIndex = 0;
  static const List<Widget> pages = <Widget>[
    Home(),
    Browse(),
    ListAnItem(),
    MyListings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        color: Colours.lightBlue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              activeColor: Colors.black,
              backgroundColor: Colours.lightBlue,
              tabActiveBorder: const Border(
                  top: BorderSide(),
                  right: BorderSide(),
                  bottom: BorderSide(),
                  left: BorderSide()),
              gap: 8,
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search_outlined,
                  text: 'Browse',
                ),
                GButton(
                  icon: Icons.currency_pound_outlined,
                  text: 'List an Item',
                ),
                GButton(
                  icon: Icons.list_outlined,
                  text: 'My Listings',
                ),
              ]),
        ),
      ),
    );
  }
}
