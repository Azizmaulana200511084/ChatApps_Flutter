import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat_pb_kel_4/ui/login_page.dart';
import 'package:chat_pb_kel_4/ui/MessageDetailPage.dart'; 
import 'package:chat_pb_kel_4/ui/search.dart';

class InboxMessagesPage extends StatefulWidget {
  final int receiverId;

  InboxMessagesPage({required this.receiverId});

  @override
  _InboxMessagesPageState createState() => _InboxMessagesPageState();
}

class _InboxMessagesPageState extends State<InboxMessagesPage> {
  List<Map<String, dynamic>> messages = [];
  late Timer timer; 

  @override
  void initState() {
    super.initState();
    fetchMessages();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchMessages()); 
  }

  @override
  void dispose() {
    timer.cancel(); 
    super.dispose();
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.1/api/inbox.php?receiver_id=${widget.receiverId}'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          messages = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  Future<void> _logout(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  void _showMessageDetail(String message, String senderUsername, int senderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailPage(
          message: message,
          senderUsername: senderUsername,
          senderId: senderId,
          receiverId: widget.receiverId,
        ),
      ),
    );
  }

  void _navigateToSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(senderId: widget.receiverId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _navigateToSearchPage(context),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(messages[index]['sender_username']),
            onTap: () => _showMessageDetail(
              messages[index]['message'],
              messages[index]['sender_username'],
              int.parse(messages[index]['sender_id']),
            ),
          );
        },
      ),
    );
  }
}
