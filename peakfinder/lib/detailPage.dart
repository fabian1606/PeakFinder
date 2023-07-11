import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:peakfinder/ble.dart';
import 'package:fl_chart/fl_chart.dart';

class SecondPage extends StatelessWidget {
  List<Color> gradientColors = [
    Color.fromARGB(255, 255, 165, 21),
    Colors.deepOrange,
  ];

  bool showAvg = false;
  final String data;
  SecondPage({required this.data});
  @override
  Widget build(BuildContext context) {
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
              child: LineChart(
                avgData([0,10,12,10,0]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData avgData(data) {
    List<FlSpot> charData = [] ;//= const [FlSpot(0, 10),FlSpot(5, 5)];
    int maxVal = 0;
    int count =0;
    data.forEach((element) {
      charData.add(FlSpot((count++).toDouble(), element.toDouble()));
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
      minX: 0,
      maxX: (data.length-1).toDouble(),
      minY: 0,
      maxY: (maxVal+2).toDouble(),

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
