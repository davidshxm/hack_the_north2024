import 'package:flutter/material.dart';

import 'inventory.dart';

void main() {
  runApp(const ScanBite());
}

class ScanBite extends StatelessWidget {
  const ScanBite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanBite',
      theme: ThemeData(
        fontFamily: 'PixelifySans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Inventory(),
      debugShowCheckedModeBanner: false,
    );
  }
}
