import 'package:auction_mobile_app/constants.dart';
import 'package:flutter/material.dart';

class ItemCardRow extends StatelessWidget {
  const ItemCardRow({
    super.key,
    required String text,
    bool isBold = false,
  })  : _text = text,
        _isBold = isBold;

  final String _text;
  final bool _isBold;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
        fit: FlexFit.loose,
        child: Text(
          _text,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.start,
          style: _isBold ? Elements.boldCardText : Elements.cardText,
        ),
      ),
    ]);
  }
}
