import 'package:flutter/material.dart';
import 'package:my_rest_api/elements.dart';

import 'package:my_rest_api/models/items_model.dart';
import 'package:my_rest_api/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:my_rest_api/colours.dart';

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

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    itemModel = (await ApiService().getItem(widget._itemId)) as ItemsModel?;
    setState(() {});
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
          backgroundColor: Colours.lightBlue),
      body: itemModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Summary',
                                  style: Elements.cardHeader,
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Price: £${itemModel!.price}',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'P&P: £${itemModel!.postageCost}',
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Bid Increment: £${itemModel!.bidIncrement}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Condition: ${itemModel!.condition}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Ends on ${formatDateTime(itemModel!.endDateTime)}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Accepts Returns: ${itemModel!.acceptReturns}'),
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
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Description',
                                  style: Elements.cardHeader,
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              itemModel!.description,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
