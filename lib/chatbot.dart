import 'package:flutter/material.dart';

import 'camera.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

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
        title: const Text('ChatBot'),
      ),
      body: Column(
        children: [
          IconButton(onPressed: () async{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Camera(),));
          }, icon: const Icon(Icons.login))
        ],
      ),
    );
  }
}

