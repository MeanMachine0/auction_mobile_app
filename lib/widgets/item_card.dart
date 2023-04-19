import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/items_model.dart';
import '../pages/item_detail.dart';
import '../widgets/item_card_row.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required ItemsModel item,
    required int accountId,
  })  : _item = item,
        _accountId = accountId;

  final ItemsModel _item;
  final int _accountId;

  Future<String> getDownloadURL(ItemsModel item) async {
    Reference reference = FirebaseStorage.instance.refFromURL(
        '${FirebaseConstants.uploadedImages}${item.id}/thumbNail.jpeg');
    String downloadURL = await reference.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      width: 100,
                      child: FutureBuilder<String>(
                        future: getDownloadURL(_item),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colours.lightBlue,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Image.network(
                              snapshot.data!,
                            );
                          }
                        },
                      ))
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    ItemCardRow(
                      text: _item.name,
                      isBold: true,
                    ),
                    ItemCardRow(text: '£${_item.price}'),
                    ItemCardRow(
                        text:
                            '${_item.numBids} ${_item.numBids != 1 ? 'bids' : 'bid'}'),
                    ItemCardRow(
                      text: Dicts.conditions.keys.firstWhere(
                          (key) => Dicts.conditions[key] == _item.condition),
                    ),
                    ItemCardRow(
                        text:
                            'Listed by ${_accountId == _item.seller ? 'you' : _item.bidders}'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ItemDetail(itemId: _item.id)));
      },
    );
  }
}
