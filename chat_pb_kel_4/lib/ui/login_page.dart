import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat_pb_kel_4/ui/inbox_page.dart';
import 'package:chat_pb_kel_4/ui/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.1/api/login.php'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('user')) {
          int userId = int.parse(responseData['user']['id']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InboxMessagesPage(receiverId: userId)),
          );
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else {
        throw Exception('Failed to authenticate: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error during login: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('An error occurred during login. Please try again later.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
