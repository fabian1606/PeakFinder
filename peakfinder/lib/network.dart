import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_ping/dart_ping.dart';
import 'ble.dart';

String ip = "0.0.0.0";
String email = "";
String password = "";
BuildContext storedContext = null as BuildContext;
final storage = new FlutterSecureStorage();



Future checkLogin() async {
    email = await storage.read(key: "email") as String;
    password = await storage.read(key: "password") as String;
    if (email == null || password == null) {
      print("no password or email");
      return false;
    } else {
      print("email: $email");
      print("password: $password");
      return true;
    }
}

login(String email, String psw) async {
  print("login in...");

//   return;
  final response = await http.post(Uri.parse('http://xps-15:3004/login'),
// Read value
      body: {'email': email, 'password': psw});

  if (response.statusCode == 200) {
    print("succsess");
    await storage.write(key: "email", value: email);
    await storage.write(key: "password", value: psw);
  } else {
    print(response.statusCode);
  }
}

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
  getIp();
  final ping = Ping('http://XPS-15:3004/getPeakData', count: 1);

  // Begin ping process and listen for output
  ping.stream.listen((event) {
    if (event.error != null) {
      print(event.error);
    }
  });
  showBackupAccountDialog(storedContext);
}

networkInit(BuildContext context) async {
  await getIp();
  storedContext = context;
}

addMessage(String message) async {
  // await checkIp();
  // messages.add(message);
  final response =
      await http.post(
        Uri.parse('http://XPS-15:3004/addData'),
        headers: {'Content-Type': 'application/json'},
        body: message);

  if (response.statusCode == 200) {
    print("succsess");
  }
  else{
    print(response.statusCode);
  }
}
