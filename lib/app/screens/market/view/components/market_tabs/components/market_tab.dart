import 'package:flutter/material.dart';

class MarketTab extends StatelessWidget {
  const MarketTab({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 16,
      ),
      child: Text(text),
    );
  }
}
