import 'package:flutter/material.dart';
import 'package:peakfinder/ble.dart';

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
        child: Text(messages.length > 0?messages[0]:""),
      ),
    );
  }
}