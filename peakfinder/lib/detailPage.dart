import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:peakfinder/ble.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:peakfinder/network.dart';
import 'package:peakfinder/types/getPeakData.dart';

class SecondPage extends StatefulWidget {
  late Future<AllPeakData> futurePeakData;

  final String data;
  final String peakId;
  SecondPage({required this.data, required this.peakId});
  // void initState() {
  //   futurePeakData = getPeakData(data);
  // }
  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  List<Color> gradientColors = [
    Color.fromARGB(255, 255, 165, 21),
    Colors.deepOrange,
  ];

  bool showAvg = false;
  @override
  Widget build(BuildContext context) {
    Future<AllPeakData> futurePeakData = getPeakData(widget.peakId);//widget.data
    String data = widget.data; // Accessing the data property
    return Scaffold(
      appBar: AppBar(
        title: Text(data),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Besucherdaten:",
              style: TextStyle(
                color: Color.fromARGB(249, 223, 152, 100),
                fontSize: 24, // Customize the font size
                fontWeight: FontWeight.bold, // Customize the font weight
              ),
            ),
            SizedBox(
              width: 300,
              height: 200,
              child: FutureBuilder<AllPeakData>(
                future: futurePeakData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.peaks[0].avgVisitors);
                    List<int> avDataList = [];
                    for(int i = 0; i < snapshot.data!.peaks.length; i++){
                      print(snapshot.data!.peaks[i].avgVisitors);
                      avDataList.add(int.parse(snapshot.data!.peaks[i].avgVisitors));
                    }
                    return LineChart(
                      avgData(avDataList),
                    );
                    // return Text("test");
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData avgData(data) {
    List<FlSpot> charData = []; //= const [FlSpot(0, 10),FlSpot(5, 5)];
    int maxVal = 0;
    int count = 0;
    data.forEach((element) {
      charData.add(FlSpot((-1 * (count++)).toDouble(), element.toDouble()));
      if (element > maxVal) {
        maxVal = element;
      }
      print(charData);
    });
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 0,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: (-1 * (data.length - 1)).toDouble(),
      maxX: 0,
      minY: 0,
      maxY: (maxVal + 2).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: charData,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
