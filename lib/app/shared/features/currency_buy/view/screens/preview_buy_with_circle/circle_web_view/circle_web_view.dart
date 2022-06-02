import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleWebView extends StatelessWidget {
  const CircleWebView(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Text(url),
    );
  }
}
