import 'package:auction_mobile_app/constants.dart';
import 'package:auction_mobile_app/pages/my_listings.dart';
import 'package:flutter/material.dart';
import 'package:auction_mobile_app/elements.dart';
import 'package:intl/intl.dart';
import 'package:auction_mobile_app/models/ended_items_model.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndedItemDetail extends StatefulWidget {
  final int _endedItemId;
  const EndedItemDetail({Key? key, required int endedItemId})
      : _endedItemId = endedItemId,
        super(key: key);

  @override
  _EndedItemDetailState createState() => _EndedItemDetailState();
}

class _EndedItemDetailState extends State<EndedItemDetail> {
  late int? accountId = 0;
  late String? token = '';
  bool IAmTheSeller = false;
  bool IAmTheBuyer = false;
  EndedItemsModel? endedItemModel;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = prefs.getInt('accountId');
    token = prefs.getString('token');
    ApiService apiService = ApiService();
    endedItemModel = await apiService.getEndedItem(widget._endedItemId, token);
    IAmTheSeller = accountId == endedItemModel!.sellerId;
    IAmTheBuyer = IAmTheSeller
        ? false
        : await apiService.amITheBuyer(endedItemModel!.id, token, true);
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
              child: CircularProgressIndicator(
                color: Colours.lightGray,
              ),
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
                                          'Price: £${endedItemModel!.price}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: double.parse(endedItemModel!
                                                  .postageCost) ==
                                              0
                                          ? [const Text('P&P: free')]
                                          : [
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
                                        Text(
                                            'Condition: ${Dicts.conditions.keys.firstWhere((key) => Dicts.conditions[key] == endedItemModel!.condition)}'),
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
                                            'Returns accepted: ${Dicts.toYesNo[endedItemModel!.acceptReturns]}')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'Bids: ${endedItemModel!.numBids}'),
                                      ],
                                    ),
                                    Column(
                                        children: IAmTheSeller
                                            ? [
                                                GestureDetector(
                                                  onTap: endedItemModel!
                                                              .buyerId !=
                                                          null
                                                      ? () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      MyListings(
                                                                          accountId:
                                                                              endedItemModel!.buyerId)));
                                                        }
                                                      : null,
                                                  child: Row(
                                                    children: endedItemModel!
                                                                .buyerId !=
                                                            null
                                                        ? [
                                                            Text(
                                                              'Buyer: ${endedItemModel!.buyerId}',
                                                              style:
                                                                  const TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationStyle:
                                                                    TextDecorationStyle
                                                                        .solid,
                                                              ),
                                                            ),
                                                          ]
                                                        : [
                                                            const Text(
                                                                'Buyer:'),
                                                          ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        'Destination: ${endedItemModel!.destinationAddress}'),
                                                  ],
                                                ),
                                              ]
                                            : IAmTheBuyer
                                                ? [
                                                    Row(children: const [
                                                      Text('Buyer: You')
                                                    ])
                                                  ]
                                                : [
                                                    Row(
                                                      children: const [
                                                        Text('Buyer: Not You')
                                                      ],
                                                    )
                                                  ]),
                                    GestureDetector(
                                      onTap: IAmTheSeller
                                          ? null
                                          : () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) => MyListings(
                                                          accountId:
                                                              endedItemModel!
                                                                  .sellerId)));
                                            },
                                      child: Row(
                                        children: [
                                          Text(
                                            IAmTheSeller
                                                ? 'Seller: You'
                                                : 'Seller: ${endedItemModel!.sellerId}',
                                            style: IAmTheSeller
                                                ? null
                                                : const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .solid,
                                                  ),
                                          ),
                                        ],
                                      ),
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
                                  endedItemModel!.description,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
