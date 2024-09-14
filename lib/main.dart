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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Inventory(),
    );
  }
}
