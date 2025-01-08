import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MessageDetailPage extends StatefulWidget {
  final String message;
  final String senderUsername;
  final int senderId;
  final int receiverId;

  MessageDetailPage({
    required this.message,
    required this.senderUsername,
    required this.senderId,
    required this.receiverId,
  });

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  TextEditingController _replyController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.43.1/message/fetch_messages.php?receiver_id=${widget.senderId}&sender_id=${widget.receiverId}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _messages = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to fetch messages');
      }
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  Future<void> _sendMessage(String reply) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.1/api/send_message.php'),
        body: {
          'sender_id': widget.senderId.toString(),
          'message': reply,
          'receiver_id': widget.receiverId.toString(),
        },
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
        _replyController.clear();
        _fetchMessages();
      } else {
        print('Failed to send message');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isCurrentUserMessage =
                    _messages[index]['sender_id'] == widget.senderId;

                Color bubbleColor = isCurrentUserMessage
                    ? Colors.blue[100]!
                    : Colors.grey[200]!;

                return Align(
                  alignment: isCurrentUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _messages[index]['sender_username'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _messages[index]['message'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _replyController,
                  decoration: InputDecoration(labelText: 'Ketikan Pesan Anda.....'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    String reply = _replyController.text.trim();
                    if (reply.isNotEmpty) {
                      _sendMessage(reply);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter a reply.'),
                      ));
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}