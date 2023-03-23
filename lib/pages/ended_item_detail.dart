import 'package:flutter/material.dart';
import 'package:my_rest_api/elements.dart';

import 'package:my_rest_api/models/ended_items_model.dart';
import 'package:my_rest_api/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:my_rest_api/colours.dart';

class EndedItemDetail extends StatefulWidget {
  final int _endedItemId;
  const EndedItemDetail({Key? key, required int endedItemId})
      : _endedItemId = endedItemId,
        super(key: key);

  @override
  _EndedItemDetailState createState() => _EndedItemDetailState();
}

class _EndedItemDetailState extends State<EndedItemDetail> {
  EndedItemsModel? endedItemModel;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    endedItemModel = (await ApiService().getEndedItem(widget._endedItemId));
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
        title: Text(endedItemModel?.name ?? 'Item Not Found'),
      ),
      body: endedItemModel == null
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
                                  'Price: £${endedItemModel!.salePrice}',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'P&P: £${endedItemModel!.postageCost}',
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Bid Increment: £${endedItemModel!.bidIncrement}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Condition: ${endedItemModel!.condition}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Ended on ${formatDateTime(endedItemModel!.endDateTime)}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Accepts Returns: ${endedItemModel!.acceptReturns}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Bids: ${endedItemModel!.numBids}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Seller: ${endedItemModel!.sellerId}'),
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
                              endedItemModel!.description,
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
