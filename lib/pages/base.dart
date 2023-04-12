import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:auction_mobile_app/pages/home.dart';
import 'package:auction_mobile_app/pages/my_listings.dart';
import 'package:auction_mobile_app/pages/browse.dart';
import 'package:auction_mobile_app/pages/list_an_item.dart';

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
  late int? accountId = 0;
  late String? token = '';
  late String? username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colours.deepDarkGray,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_carousel_outlined),
            selectedIcon: Icon(Icons.view_carousel),
            label: 'Browse',
          ),
          NavigationDestination(
            icon: Icon(Icons.create_outlined),
            selectedIcon: Icon(Icons.create),
            label: 'List an Item',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'My Listings',
          ),
        ],
      ),
    );
  }
}
