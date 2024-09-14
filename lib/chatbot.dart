import 'package:flutter/material.dart';
import 'inventory.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Import the http package

class chatResponse {
  String message;
  chatResponse({
    required this.message,
  });

  factory chatResponse.fromJson(Map<String, dynamic> json) {
    dynamic response = json['response']['text'];
    return chatResponse(
        message: response
    );
  }

  // Convert Meta to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

Future<chatResponse> createChatResponse(String payload) async {
  final response = await http.post(
    Uri.parse('https://htn2024-backend-uftm.vercel.app/api/ChatBot'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'payload': payload,
    }),
  );

  if (response.statusCode == 200) {
    return chatResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load chat response');
  }
}

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<StatefulWidget> createState() => _ChatBot();
}

class _ChatBot extends State<ChatBot> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _handleSubmitted(String text) async {
    _controller.clear();
    setState(() {
      _messages.add('You: $text');
    });

    try {
      chatResponse response = await createChatResponse(text);
      setState(() {
        _messages.add('Bot: ${response.message}');
      });
    } catch (e) {
      setState(() {
        _messages.add('Bot: Error occurred');
      });
    }
  }

  void _backToInventory() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Inventory()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: _backToInventory,
            ),
            SizedBox(width: 8.0), // Space between icon and title
            Text('ChatBot'),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message),
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _handleSubmitted(_controller.text);
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
