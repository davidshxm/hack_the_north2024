import 'package:flutter/material.dart';

import 'chatbot.dart';

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
        title: Text('Details'),
      ),
      body: Column(
        children: [
          IconButton(onPressed: () async{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatBot(),));
          }, icon: Icon(Icons.login))
        ],
      ),
    );
  }
}

