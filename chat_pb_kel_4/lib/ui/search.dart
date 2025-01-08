import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat_pb_kel_4/ui/MessageDetailPage.dart'; 

class SearchPage extends StatefulWidget {
  final int senderId;
  SearchPage({required this.senderId}); 

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  Future<void> _searchUsers(String query) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.1/api/search.php?query=$query'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> results =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          searchResults = results;
        });
      } else {
        throw Exception('Failed to search users');
      }
    } catch (error) {
      print('Error searching users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      _searchUsers(query);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]['username']),
                  onTap: () {
                    String senderUsername = searchResults[index]['username'];
                    int receiverId = int.parse(searchResults[index]['id']);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageDetailPage(
                          senderUsername: senderUsername,
                          receiverId: widget.senderId,
                          senderId: receiverId, 
                          message: '', 
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}