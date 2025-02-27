import 'package:flutter/material.dart';

import 'loader.dart';

class ScaffoldLoader extends StatelessWidget {
  const ScaffoldLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: const Loader(
        color: Colors.white,
      ),
    );
  }
}
