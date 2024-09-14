import 'package:flutter/material.dart';

class Details extends StatefulWidget {
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
        title: Text('ScanBite'),
      ),
      body: Column(
        children: [
          IconButton(onPressed: () async{
          }, icon: Icon(Icons.login))
        ],
      ),
    );
  }
}

