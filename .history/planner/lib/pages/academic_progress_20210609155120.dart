import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class Progression extends StatefulWidget {
  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  // Variables
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  // Methods

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progression'),
      ),
      body: Container(
        child: Center(
          child: LineChart(
                      isShowingMainData ? sampleData1() : sampleData2(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
        )
      ),
    );
  }
}
