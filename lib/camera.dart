import 'package:flutter/material.dart';
import 'inventory.dart';


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
        title: Text('Camera'),
      ),
      body: Column(
        children: [
          IconButton(onPressed: () async{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Inventory(),));
          }, icon: Icon(Icons.login))
        ],
      ),
    );
  }
}

