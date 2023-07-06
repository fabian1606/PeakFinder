import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'mqtt.dart';

import 'dart:async';
import 'dart:io' show Platform;

MapController controller = MapController(
  initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  areaLimit: BoundingBox(
    east: 10.4922941,
    north: 47.8084648,
    south: 45.817995,
    west: 5.9559113,
  ),
);


int count = 0;

Future<void> main() async {
  connectMqtt();
  controller.dispose();

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

  final Uuid serviceUuid = Uuid.parse("07c0e33c-6cc2-4a68-a7df-478e334e0ed6");
  final Uuid characteristicUuid =
      Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  void _startScan() async {
    // bool permGranted = false;
    setState(() {
      _scanStarted = true;
    });
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
            setState(() {
              _ubiqueDevice = device;
              _foundDeviceWaitingToConnect = true;
            });
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
      final response =
          await flutterReactiveBle.readCharacteristic(characteristic);
      print(String.fromCharCodes(response));
    });
  }

  @override
  void dispose() {
    _scanStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 117, 115, 115),
      appBar: AppBar(
        title: Text('Peak Finder'),
        backgroundColor: Color(0xFF242227),
      ),
      body: buildOSMWidget(),
      // child: Center(
      //   child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       ElevatedButton(
      //         onPressed: () {
      //           _startScan();
      //         },
      //         child: Text('Scan'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           sendMqttMessage('test', 'iot2/peakfinder');
      //         },
      //         child: Text('sendMqtt'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

Widget buildOSMWidget() {
  return OSMFlutter(
    controller: controller,
    userTrackingOption: UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
    initZoom: 12,
    minZoomLevel: 8,
    maxZoomLevel: 14,
    stepZoom: 1.0,
    userLocationMarker: UserLocationMaker(
      personMarker: MarkerIcon(
        icon: Icon(
          Icons.location_history_rounded,
          color: Colors.red,
          size: 48,
        ),
      ),
      directionArrowMarker: MarkerIcon(
        icon: Icon(
          Icons.double_arrow,
          size: 48,
        ),
      ),
    ),
    roadConfiguration: RoadOption(
      roadColor: Colors.yellowAccent,
    ),
    markerOption: MarkerOption(
      defaultMarker: MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.blue,
          size: 56,
        ),
      ),
    ),
  );
}
