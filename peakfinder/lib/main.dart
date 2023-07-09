import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peakfinder/peakBook.dart';

import 'mqtt.dart';

import "detailPage.dart";
import "style.dart";
import "ble.dart";

import 'dart:async';
import 'dart:io' show Platform;
import 'network.dart';

int count = 0;

final List<String> mountains = [
  "mount blanc",
  "monte rosa",
  "monte bianco",
  "monte cervino",
  "monte rosa",
  "monte bianco"
];

Future<void> main() async {
  connectMqtt();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: []); // This hides the status bar
  runApp(
    MaterialApp(
      title: 'Peak Finder',
      home: PeakFinder(),
      theme: appTheme(),
      routes: {
        '/details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return SecondPage(data: args as String);
        },
        '/peakBook': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return PeakPage(data: args as String);
        },
      },
    ),
  );
}

class PeakFinder extends StatefulWidget {
  @override
  _PeakFinderState createState() => _PeakFinderState();
}

class _PeakFinderState extends State<PeakFinder> {
    late BuildContext _storedContext; // Variable to store the BuildContext
  @override
  void initState() {
    super.initState();
    _storedContext = context; // Store the BuildContext
    networkInit(context);
    startScan(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 117, 115, 115),
        appBar: AppBar(
          title: Text('Peak Finder',
              style: TextStyle(
                color: Color.fromARGB(249, 223, 152, 100),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: Container(
          color: Color(0XFF242227),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(30.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Mountains:',
                    style: TextStyle(
                      color: Color.fromARGB(249, 223, 152, 100),
                      fontSize: 24, // Customize the font size
                      fontWeight: FontWeight.bold, // Customize the font weight
                    ),
                  )),

              Container(
                padding: EdgeInsets.all(30.0),
                height: 600,
                child: ListView.builder(
                  itemCount: mountains.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: mountains[index],
                            );
                          },
                          child: Container(
                            child: ListTile(
                              title: Text(
                                mountains[index],
                                style: TextStyle(
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        ElevatedButton(
                          onPressed: () {
                            startScan(context);
                          },
                          child: Text('Scan'),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        )
        // child: Center(
        //   child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
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
