import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../widgets/item_card.dart';

class ItemCardList extends StatelessWidget {
  const ItemCardList({
    super.key,
    required List<ItemModel> itemsModel,
    required int accountId,
  })  : _itemsModel = itemsModel,
        _accountId = accountId;

  final List<ItemModel>? _itemsModel;
  final int _accountId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _itemsModel!.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 2,
            ),
            child: ItemCard(
              item: _itemsModel![index],
              accountId: _accountId,
            ));
      },
    );
  }
}
