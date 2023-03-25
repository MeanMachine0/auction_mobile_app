import 'package:flutter/material.dart';

import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListAnItem extends StatefulWidget {
  const ListAnItem({Key? key}) : super(key: key);

  @override
  _ListAnItemState createState() => _ListAnItemState();
}

class _ListAnItemState extends State<ListAnItem> {
  late List<ItemsModel>? _itemsModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _itemsModel = (await ApiService().getItems());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your New Listing'),
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
                          Text(
                              'Starting Price: ${_itemsModel![index].price.toString()}'),
                          Text(
                              'Condition: ${_itemsModel![index].condition.toString()}'),
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
    );
  }
}
