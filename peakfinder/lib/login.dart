import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'network.dart';

final storage = new FlutterSecureStorage();

void showLoginDialog(BuildContext context) {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      //choose random message
      title: Text("Set Server IP"),
      content: Container(
        height: 120,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Email"),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            Text("Password"),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text;
                String password = _passwordController.text;
                print('Email: $email');
                print('Password: $password');
                // savePW(email, password);
                // Navigator.pop(context);
                login(email, password);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    ),
  );
}


class LoginPage extends StatelessWidget {
  final String data;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginPage({required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Email"),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            Text("Password"),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text;
                String password = _passwordController.text;
                print('Email: $email');
                print('Password: $password');
                // savePW(email, password);
                // Navigator.pop(context);
                login(email, password);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}