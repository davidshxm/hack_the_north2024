import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatBot();
}

class _ChatBot extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('ChatBot'),
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

