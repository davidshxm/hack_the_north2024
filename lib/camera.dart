import 'package:flutter/material.dart';

import 'details.dart';

class Camera extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Camera();
}

class _Camera extends State<Camera> {
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Details(),));
          }, icon: Icon(Icons.login))
        ],
      ),
    );
  }
}

