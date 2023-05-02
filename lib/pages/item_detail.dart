import 'package:auction_mobile_app/constants.dart';
import 'package:auction_mobile_app/pages/my_listings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:auction_mobile_app/models/item_model.dart';
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
  ItemModel? itemModel;
  int? accountId;
  String? token;
  String? username;
  TextEditingController bidController = TextEditingController();
  String message = '';
  var messageColour = Colours.lightGray;
  bool IAmTheSeller = false;
  bool IAmTheTopBidder = false;
  String? downloadURL;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    accountId = prefs.getInt('accountId');
    username = prefs.getString('username');
    ApiService apiService = ApiService();
    itemModel = await apiService.getItem(widget._itemId, token);
    IAmTheSeller = accountId == itemModel!.seller;
    IAmTheTopBidder = IAmTheSeller
        ? false
        : await apiService.amITheBuyer(itemModel!.id, token, false);
    try {
      Reference reference = FirebaseStorage.instance.refFromURL(
          '${FirebaseConstants.uploadedImages}${itemModel!.id}/smallerImage');
      downloadURL = await reference.getDownloadURL();
    } catch (e) {
      throw Exception('Image not found');
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDateTime(DateTime dateTime) {
    var formatter = DateFormat('MMM d y \'at\' HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isLoading ? 'Loading...' : itemModel?.name ?? 'Item Not Found'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : itemModel == null
              ? const Center(child: Text('Item not found.'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                            style: Elements.cardText,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'P&P: ${double.parse(itemModel!.postageCost) == 0 ? 'free' : '£${itemModel!.postageCost}'} ',
                                            style: Elements.cardText,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Bid Increment: £${itemModel!.bidIncrement}',
                                            style: Elements.cardText,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Condition: ${Dicts.conditions.keys.firstWhere((key) => Dicts.conditions[key] == itemModel!.condition)}',
                                            style: Elements.cardText,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${!itemModel!.ended ? 'Ends' : 'Ended'} on ${formatDateTime(itemModel!.endDateTime)}',
                                            style: Elements.cardText,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Returns accepted: ${Dicts.toYesNo[itemModel!.acceptReturns]}',
                                            style: Elements.cardText,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Bids: ${itemModel!.numBids}',
                                            style: Elements.cardText,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: IAmTheSeller
                                            ? [
                                                GestureDetector(
                                                  onTap: itemModel!.buyer !=
                                                          null
                                                      ? () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      MyListings(
                                                                          accountId:
                                                                              itemModel!.buyer)));
                                                        }
                                                      : null,
                                                  child: Row(
                                                    children: itemModel!
                                                                .buyer !=
                                                            null
                                                        ? [
                                                            Text(
                                                              '${!itemModel!.ended ? 'Top Bidder' : 'Buyer'}: ${itemModel!.buyer}',
                                                              style:
                                                                  const TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationStyle:
                                                                    TextDecorationStyle
                                                                        .solid,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ]
                                                        : [
                                                            Text(
                                                              !itemModel!.ended
                                                                  ? 'Top Bidder'
                                                                  : 'Buyer',
                                                              style: Elements
                                                                  .cardText,
                                                            ),
                                                          ],
                                                  ),
                                                ),
                                              ]
                                            : IAmTheTopBidder
                                                ? [
                                                    Text(
                                                      '${!itemModel!.ended ? 'Top Bidder' : 'Buyer'}: You',
                                                      style: Elements.cardText,
                                                    )
                                                  ]
                                                : [
                                                    Text(
                                                      '${!itemModel!.ended ? 'Top Bidder' : 'Buyer'}: Not You',
                                                      style: Elements.cardText,
                                                    )
                                                  ],
                                      ),
                                      GestureDetector(
                                        onTap: IAmTheSeller
                                            ? null
                                            : () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            MyListings(
                                                              accountId:
                                                                  itemModel!
                                                                      .seller,
                                                              username:
                                                                  itemModel!
                                                                      .bidders,
                                                            )));
                                              },
                                        child: Row(
                                          children: [
                                            Text(
                                              IAmTheSeller
                                                  ? 'Seller: You'
                                                  : 'Seller: ${itemModel!.bidders}',
                                              style: IAmTheSeller
                                                  ? Elements.cardText
                                                  : const TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationStyle:
                                                          TextDecorationStyle
                                                              .solid,
                                                      fontSize: 16,
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
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      itemModel!.description,
                                      style: Elements.cardText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (downloadURL != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Image.network(
                            downloadURL!,
                            loadingBuilder: Widgets().customLoadingBuilder,
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        child: itemModel!.ended
                            ? null
                            : Form(
                                key: bidFormKey,
                                child: Center(
                                  child: !IAmTheSeller && token != null
                                      ? Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: TextFormField(
                                                controller: bidController,
                                                keyboardType:
                                                    const TextInputType
                                                            .numberWithOptions(
                                                        decimal: true),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(Regexes.money),
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                  prefix: Text('£'),
                                                  label: Text('Your Bid'),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colours
                                                                      .red)),
                                                  errorStyle: TextStyle(
                                                      color: Colours.red),
                                                ),
                                                validator: (bid) {
                                                  double minBid = double.parse(
                                                          itemModel!.price) +
                                                      double.parse(itemModel!
                                                          .bidIncrement);
                                                  if (bid! == '') {
                                                    return 'Please enter a bid.';
                                                  } else if (double.parse(bid) <
                                                      minBid) {
                                                    return 'Could not submit bid; minimum bid is $minBid';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (bidFormKey.currentState!
                                                        .validate() &&
                                                    token != null) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  ApiService apiService =
                                                      ApiService();
                                                  double bid = double.parse(
                                                      bidController.text);
                                                  message = await apiService
                                                      .submitBid(
                                                    bid,
                                                    widget._itemId,
                                                    accountId!,
                                                    token!,
                                                  );
                                                  messageColour =
                                                      Colours.lightGray;
                                                  _getData();
                                                }
                                              },
                                              child: const Text('Submit Bid',
                                                  style: TextStyle(
                                                      color:
                                                          Colours.lightGray)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    message,
                                                    style: TextStyle(
                                                        color: messageColour),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : token != null
                                          ? Column(
                                              children: const [
                                                Text('You listed this item.'),
                                                SizedBox(height: 20),
                                              ],
                                            )
                                          : Column(
                                              children: const [
                                                Text(
                                                    'You must be logged in to bid on items.'),
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                )),
                      )
                    ],
                  ),
                ),
    );
  }
}
