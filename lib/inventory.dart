import 'package:flutter/material.dart';

import 'camera.dart';

class Inventory extends StatefulWidget {
  Inventory({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InventoryPage();
}

class _InventoryPage extends State<Inventory> {
  @override
  void initState(){
    super.initState();
  }

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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Camera(),));
          }, icon: Icon(Icons.login))
        ],
      ),
    );
  }
}
