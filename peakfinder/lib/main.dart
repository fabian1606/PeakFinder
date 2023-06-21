import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:location_permissions/location_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mqtt.dart';

import 'dart:async';
import 'dart:io' show Platform;


int count = 0;



Future<void> main() async {
  
  connectMqtt();

  runApp(
    MaterialApp(
      title: 'Peak Finder',
      home: PeakFinder(),
    ),
  );
}

class PeakFinder extends StatefulWidget {
  @override
  _PeakFinderState createState() => _PeakFinderState();
}

class _PeakFinderState extends State<PeakFinder> {
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;

  late DiscoveredDevice _ubiqueDevice;
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _rxCharacteristic;

  final Uuid serviceUuid = Uuid.parse("75C276C3-8F97-20BC-A143-B354244886D4");
  final Uuid characteristicUuid =
      Uuid.parse("6ACF4F08-CC9D-D495-6B41-AA7E60C4E8A6");

  void _startScan() async {
    // bool permGranted = false;
    setState(() {
      _scanStarted = true;
    });
    await Permission.location.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    if (await Permission.location.isGranted && await Permission.bluetoothScan.isGranted && await Permission.bluetoothConnect.isGranted) {
      try {
        _scanStream = flutterReactiveBle
            .scanForDevices(withServices: [serviceUuid]).listen((device) {
          if (device.name == 'UBIQUE') {
            print('Found device: ${device.name}');
            setState(() {
              _ubiqueDevice = device;
              _foundDeviceWaitingToConnect = true;
            });
          }
        });
      } catch (e) {
        print('Error while scanning for devices: $e');
      }
    } else {
      print('Location permission not granted');
    }
  }


  @override
  void dispose() {
    _scanStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _startScan();
                },
                child: Text('Scan'),
              ),
              ElevatedButton(
                onPressed: () {
                  sendMqttMessage('test', 'iot2/peakfinder');
                },
                child: Text('sendMqtt'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
