import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<StatefulWidget> createState() => _Details();
}

class _Details extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(int i = 0; i < 100; i++)
              Text("Hello World"),
          ],
        ),
    );
  }
}

