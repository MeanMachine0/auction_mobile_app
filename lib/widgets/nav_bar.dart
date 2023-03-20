import 'package:flutter/material.dart';
import 'package:my_rest_api/colours.dart';
import 'package:my_rest_api/pages/browse.dart';
import 'package:my_rest_api/pages/home.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 16,
      unselectedFontSize: 16,
      showUnselectedLabels: true,
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemSelected,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colours.darkGray,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colours.lightBlue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse',
          backgroundColor: Colours.lightBlue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.currency_pound),
          label: 'List an Item',
          backgroundColor: Colours.lightBlue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'My Bids',
          backgroundColor: Colours.lightBlue,
        ),
      ],
    );
  }
}
