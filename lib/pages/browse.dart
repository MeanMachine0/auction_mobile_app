import 'package:flutter/material.dart';

import 'package:my_rest_api/models/items_model.dart';
import 'package:my_rest_api/pages/list_an_item.dart';
import 'package:my_rest_api/pages/my_bids.dart';
import 'package:my_rest_api/services/api_service.dart';
import 'package:my_rest_api/pages/home.dart';
import 'package:my_rest_api/widgets/nav_bar.dart';

class Browse extends StatefulWidget {
  const Browse({Key? key}) : super(key: key);

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  late List<ItemsModel>? _itemsModel = [];
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _itemsModel = (await ApiService().getItems());
    setState(() {});
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const Home();
        break;
      case 1:
        page = const Browse();
        break;
      case 2:
        page = const ListAnItem();
        break;
      case 3:
        page = const MyBids();
        break;
      default:
        throw UnimplementedError('No widget for $_selectedIndex');
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction App'),
      ),
      body: _itemsModel == null || _itemsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _itemsModel!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Item: ${_itemsModel![index].name}'),
                          Text(
                              'Current Price: £${_itemsModel![index].price.toString()}'),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_itemsModel![index].description),
                          Text(_itemsModel![index].sellerId.toString()),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigationItemSelected,
      ),
    );
  }
}
