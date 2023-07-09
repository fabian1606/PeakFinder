import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String data;
  SecondPage({required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data),
      ),
      body: Center(
        child: Text('This is the second page.'),
      ),
    );
  }
}