import 'package:flutter/material.dart';

import 'package:my_rest_api/models/items_model.dart';
import 'package:my_rest_api/pages/list_an_item.dart';
import 'package:my_rest_api/pages/my_bids.dart';
import 'package:my_rest_api/services/api_service.dart';
import 'package:my_rest_api/pages/home.dart';
import 'package:my_rest_api/widgets/nav_bar.dart';
import 'package:my_rest_api/pages/browse.dart';
import 'package:intl/intl.dart';

class ItemDetail extends StatefulWidget {
  final int _itemId;
  const ItemDetail({Key? key, required int itemId})
      : _itemId = itemId,
        super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  ItemsModel? itemModel;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    itemModel = (await ApiService().getItem(widget._itemId));
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

  String formatDateTime(DateTime dateTime) {
    var formatter = DateFormat('MMM d y \'at\' HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemModel?.name ?? 'Item Not Found'),
        backgroundColor: Colors.lightBlue,
      ),
      body: itemModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Price: £${itemModel!.price}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('P&P: £${itemModel!.postageCost}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Bid Increment: £${itemModel!.bidIncrement}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Condition: ${itemModel!.condition}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Ends on ${formatDateTime(itemModel!.endDateTime)}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Accepts Returns: ${itemModel!.acceptReturns}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Bids: ${itemModel!.numBids}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Seller: ${itemModel!.sellerId}'),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigationItemSelected,
      ),
    );
  }
}
