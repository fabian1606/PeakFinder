import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:permission_handler/permission_handler.dart';

import 'dart:convert';

import 'dart:async';
import 'dart:io' show Platform;

bool _foundDeviceWaitingToConnect = false;
bool _scanStarted = false;
bool _connected = false;
bool popUp = false;
final peakMeassage = [ "Gipfel erreicht! Du bist der Gipfelstürmer!", "Herzlichen Glückwunsch! Gipfel, du hast es geschafft!", "Auf dem Gipfel angekommen? Ab jetzt nur noch Bergab!", "Gipfel erreicht! Kein Berg ist zu hoch für dich!", "Du hast den Gipfel erobert! Zeit für ein Sieges-Selfie!", "Glückwunsch, du bist der König des Berges!", "Gipfel bezwungen! Wer braucht schon einen Aufzug?", "Gratuliere zum Gipfelsieg! Der Berg vermisst dich bereits.", "Gipfel erreicht! Ab jetzt kannst du alles von oben betrachten.", "Du hast den Gipfel erklommen! Höhenangst? Kein Problem für dich!" ];
String msg = "";
int msgIndex = 65535;
int mountainId = 0;
String mountainName = "";

List<String> messages = [];

late DiscoveredDevice _ubiqueDevice;
final flutterReactiveBle = FlutterReactiveBle();
late StreamSubscription<DiscoveredDevice> _scanStream;
late QualifiedCharacteristic _rxCharacteristic;

final Uuid serviceUuid = Uuid.parse("07c0e33c-6cc2-4a68-a7df-478e334e0ed6");
final Uuid characteristicUuid =
    Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

void dispose() {
  _scanStream.cancel();
  // super.dispose();
}

void startScan(BuildContext context) async {
  // bool permGranted = false;
  // setState(() {
  //   _scanStarted = true;
  // });
  await Permission.location.request();
  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
  // await Permission.internet.request();

  print(await Permission.location.isGranted &&
      await Permission.bluetoothScan.isGranted &&
      await Permission.bluetoothConnect.isGranted);
  if (await Permission.location.isGranted &&
      await Permission.bluetoothScan.isGranted &&
      await Permission.bluetoothConnect.isGranted) {
    try {
      print("count:");
      _scanStream = flutterReactiveBle.scanForDevices(
          withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
        // print(device.serviceUuids);
        // .scanForDevices(){
        if (device.name == 'ESP32_PeakFinder') {
          print('Found device: ${device.name}');
          flutterReactiveBle.discoverServices(device.id).then((services) {
            services.forEach((service) {
              if (service.serviceId == serviceUuid) {
                print(service.serviceId);
                _connectToDevice(device.id,context);
              }
            });
          });
          // setState(() {
          //   _ubiqueDevice = device;
          //   _foundDeviceWaitingToConnect = true;
          // });
        } else {
          // print('Found other device: ${device.name}');
        }
      });
    } catch (e) {
      print('Error while scanning for devices: $e');
    }
  } else {
    print('Location permission not granted');
  }
}
void showBackupAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      //choose random message
      
      title: Text(peakMeassage[Random().nextInt(10)]),
      content: Container(
        height: 100,
        width: 100,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            popUp = false;
            Navigator.pushNamed(context,'/peakBook',arguments: messages[0]);
          },
          child: Text('Gipfelbuch anzeigen'),
        )
      ),
    ),
  );
}


void _connectToDevice(String deviceId,BuildContext context) {
  // We're done scanning, we can cancel it
  _scanStream.cancel();
  // Let's listen to our connection so we can make updates on a state change
  Stream<ConnectionStateUpdate> _currentConnectionStream = flutterReactiveBle
      .connectToAdvertisingDevice(
          id: deviceId,
          prescanDuration: const Duration(seconds: 3),
          withServices: <Uuid>[]);

  _currentConnectionStream.listen((event) async {
    print(":::::::: ${event.connectionState.name}");
    final characteristic = QualifiedCharacteristic(
        serviceId: serviceUuid,
        characteristicId: characteristicUuid,
        deviceId: deviceId);

    try {
      // Subscribe to characteristic notifications
      final notificationStream =
          flutterReactiveBle.subscribeToCharacteristic(characteristic);

      // Listen for notifications
      notificationStream.listen((event) async {
        if (event.length < 2) return;
        final newMsg = String.fromCharCodes(event.sublist(2));
        final index = (event[0] << 8) | event[1];
        if (index == 0) {
          msgIndex = -1;
          msg = "";
          messages.clear();
        }
        if (index > msgIndex) {
          msgIndex = index;
          msg += newMsg;
          print(index);
        }
        if (index == 65535) {
          if (msg.contains(String.fromCharCode(0xFF))) {
            mountainId = int.parse(msg[0]);
            final characterChange = msg.indexOf(String.fromCharCode(0xFF));

            if (msg.length > characterChange + 1) {
              String str = msg.substring(characterChange + 1);
              final usersPerHour = str.split(",");
              List<int> uint8List = [];
              for (int i = 0; i < usersPerHour.length; i++) {
                try {
                  uint8List.add(int.parse(usersPerHour[i]));
                } catch (e) {}
              }
              print(uint8List);
            }
            String jsonString = msg.substring(1, characterChange) + ']}';
            Map<String, dynamic> jsonData = jsonDecode(jsonString);
            List<dynamic> arr = jsonData['arr'];
            mountainName = jsonData['a'].toString();
            String adddataJsonFIle = "";
            for (var obj in arr) {
              messages.add(obj['msg']);
            }
            if(!popUp){
              showBackupAccountDialog(context);
              popUp = true;
            }
            // get the hour now
            DateTime now = DateTime.now();
            // make a timestamp with JJMMDD
            // String timestamp = now.year.toString()+now.month.toString()+now.day.toString()+now.hour.toString();
                
            // print(timestamp);

            print("id: "+mountainId.toString());
            print("message: "+ messages.toString()+jsonString);
          }
        }
      });
    } catch (e) {
      print('Failed to subscribe to notifications: $e');
      // Handle any errors that occur during the subscription process
    }

    try {
      // Read the characteristic value
      final response =
          await flutterReactiveBle.readCharacteristic(characteristic);
      print('Read characteristic value: ${String.fromCharCodes(response)}');
    } catch (e) {
      print('Failed to read characteristic: $e');
      // Handle any errors that occur during the read operation
    }
  });
}
