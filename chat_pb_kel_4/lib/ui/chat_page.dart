import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final response = await http.get(Uri.parse('http://192.168.43.1/api/message.php'));
    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body)['messages']; 
      List<Map<String, dynamic>> parsedMessages = List<Map<String, dynamic>>.from(responseData); 
      
      setState(() {
        messages = parsedMessages;
      });
    } else {
      // Handle error
      print('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Row(
            mainAxisAlignment: message['sender'] == 'me' ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: message['sender'] == 'me' ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  message['message'],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
