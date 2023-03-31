import 'package:flutter/material.dart';

import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/pages/item_detail.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Browse extends StatefulWidget {
  const Browse({Key? key}) : super(key: key);

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
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
        title: const Text('Active Items'),
      ),
      body: _itemsModel == null || _itemsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colours.lightGray,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _itemsModel!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                ItemDetail(itemId: _itemsModel![index].id)));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: Text(
                                '${_itemsModel![index].name} - £${_itemsModel![index].price.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
    );
  }
}
