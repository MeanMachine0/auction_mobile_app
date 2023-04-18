import 'package:flutter/material.dart';
import '../models/items_model.dart';
import '../widgets/item_card.dart';

class ItemCardList extends StatelessWidget {
  const ItemCardList({
    super.key,
    required List<ItemsModel> itemsModel,
    required int accountId,
    bool scrollable = true,
  })  : _itemsModel = itemsModel,
        _accountId = accountId,
        _scrollable = scrollable;

  final List<ItemsModel>? _itemsModel;
  final int _accountId;
  final bool _scrollable;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: _scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: _itemsModel!.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _scrollable ? 20 : 0,
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
