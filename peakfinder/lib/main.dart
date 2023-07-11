import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peakfinder/peakBook.dart';

import 'mqtt.dart';

import "detailPage.dart";
import "style.dart";
import "ble.dart";
import "login.dart";

import 'dart:async';
import 'dart:io' show Platform;
import 'network.dart';
import 'types/allPeaks.dart';

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
      debugShowCheckedModeBanner: false,
      home: PeakFinder(),
      theme: appTheme(),
      routes: {
        '/test': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return PeakFinder();
        },
        '/details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return SecondPage(data: args as String);
        },
        '/peakBook': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return PeakPage(data: args as String);
        },
        '/login': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return LoginPage(data: args as String);
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
  late Future<Peaks> futurePeaks;
  @override
  void initState() {
    super.initState();
    _storedContext = context; // Store the BuildContext
    networkInit(context);
    startScan(context);
    checkLogin();
    futurePeaks = getAllPeaks();
    // if (!checkLogin()){
    //   Navigator.pushNamed( context, '/login', arguments: 'test', );
    // }
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
                child: FutureBuilder<Peaks>(
                  future: futurePeaks,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.peaks.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/details',
                                arguments: snapshot.data!.peaks[index].peakName,
                              );
                            },
                            child: Container(
                              child: ListTile(
                                title: Text(
                                  snapshot.data!.peaks[index].peakName,
                                  style: TextStyle(
                                    color: Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                padding: EdgeInsets.all(30.0),
                height: 500,
              )
            ],
          ),
        )
        );
  }
}
