import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ble.dart';

String ip = "0.0.0.0";
BuildContext storedContext = null as BuildContext;

saveIp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('ip', ip);
}

getIp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ip = prefs.getString('ip') ?? "0.0.0.0";
}

void showBackupAccountDialog(BuildContext context) {
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
          children: [
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'IP Adresse',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //set ip to value of textfield
                Navigator.of(context).pop();
                ip = _textFieldController.text;
                print(ip);
                saveIp();
                checkIp();
              },
              child: Text('Ip Speichern'),
            )
          ],
        ),
      ),
    ),
  );
}

checkIp() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.188.140:3003/getPeakData'));

    if (response.statusCode == 200) {
      print("succsess");
    } else {
      showBackupAccountDialog(storedContext);
    }
  } catch (e) {
    showBackupAccountDialog(storedContext);
  }
}

networkInit(BuildContext context) async {
  await getIp();
  storedContext = context;
}

addMessage(String message) async {
  // await checkIp();
  messages.add(message);
  final response =
      await http.get(Uri.parse('http://192.168.188.140:3003/getPeakData'));

  if (response.statusCode == 200) {
    print("succsess");
  }
}
