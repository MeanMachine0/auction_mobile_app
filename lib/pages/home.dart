import 'package:flutter/material.dart';

import 'package:my_rest_api/models/ended_items_model.dart';
import 'package:my_rest_api/pages/ended_item_detail.dart';
import 'package:my_rest_api/services/api_service.dart';
import 'package:my_rest_api/colours.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<EndedItemsModel>? _EndedItemsModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _EndedItemsModel = (await ApiService().getEndedItems());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Recently Sold Items'),
          backgroundColor: Colours.lightBlue),
      body: _EndedItemsModel == null || _EndedItemsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _EndedItemsModel!.where((item) => item.sold).length,
                itemBuilder: (context, index) {
                  EndedItemsModel item = _EndedItemsModel!
                      .where((item) => item.sold)
                      .toList()[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                EndedItemDetail(endedItemId: item.id)));
                      },
                      child: Card(
                        color: Colours.lightGray,
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                      '${item.name} - £${item.salePrice.toString()}'),
                                ),
                              ],
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
