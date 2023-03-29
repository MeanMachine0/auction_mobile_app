import 'package:auction_mobile_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:auction_mobile_app/elements.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemDetail extends StatefulWidget {
  final int _itemId;
  const ItemDetail({Key? key, required int itemId})
      : _itemId = itemId,
        super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final bidFormKey = GlobalKey<FormState>();
  ItemsModel? itemModel;
  int? accountId;
  String? token;
  String? username;
  TextEditingController bidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    itemModel = (await ApiService().getItem(widget._itemId));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = prefs.getInt('accountId');
    token = prefs.getString('token');
    username = prefs.getString('username');
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
      ),
      body: itemModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
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
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Price: £${itemModel!.price}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: double.parse(
                                                  itemModel!.postageCost) ==
                                              0
                                          ? [const Text('P&P: free')]
                                          : [
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
                                        Text(
                                            'Condition: ${itemModel!.condition}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'Ends on ${formatDateTime(itemModel!.endDateTime)}'),
                                      ],
                                    ),
                                    Row(
                                      children: itemModel!.acceptReturns
                                          ? [
                                              const Text(
                                                  'Returns accepted: yes')
                                            ]
                                          : [
                                              const Text(
                                                  'Returns accepted: no'),
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  itemModel!.description,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                      key: bidFormKey,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 125,
                              child: TextFormField(
                                controller: bidController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      Regexes.money),
                                ],
                                decoration: const InputDecoration(
                                  prefix: Text('£'),
                                  label: Text('Your Bid'),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colours.red)),
                                  errorStyle: TextStyle(color: Colours.red),
                                ),
                                validator: (bid) {
                                  double minBid =
                                      double.parse(itemModel!.price) +
                                          double.parse(itemModel!.bidIncrement);
                                  if (bid! == '') {
                                    return 'Please enter a bid.';
                                  } else if (double.parse(bid) < minBid) {
                                    return 'Could not submit bid; minimum bid is $minBid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (bidFormKey.currentState!.validate() &&
                                    token != null) {
                                  ApiService apiService = ApiService();
                                  double bid = double.parse(bidController.text);
                                  apiService.submitBid(
                                      bid, widget._itemId, accountId!, token!);
                                  setState(() {});
                                }
                              },
                              child: const Text('Submit Bid'),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
    );
  }
}
