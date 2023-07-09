import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:permission_handler/permission_handler.dart';

import 'dart:async';
import 'dart:io' show Platform;

bool _foundDeviceWaitingToConnect = false;
bool _scanStarted = false;
bool _connected = false;

String msg = "";
int msgIndex = 65535;

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

void startScan() async {
  // bool permGranted = false;
  // setState(() {
  //   _scanStarted = true;
  // });
  await Permission.location.request();
  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();

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
                _connectToDevice(device.id);
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

void _connectToDevice(String deviceId) {
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
        if(index == 0) msgIndex = -1;
        if (index > msgIndex) {
          msg += newMsg;
          msgIndex = index;
          print(index);
        }
        if (index == 65535) {
          print(msg);
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
