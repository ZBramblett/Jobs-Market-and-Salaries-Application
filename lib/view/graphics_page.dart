import 'package:finalexam_salaries/view/UI_functions.dart';
import 'package:finalexam_salaries/widgets/pie_chart_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphicsPageScreen extends StatefulWidget {
  const GraphicsPageScreen({super.key});

  @override
  State<GraphicsPageScreen> createState() => _GraphicsPageScreenState();
}

class _GraphicsPageScreenState extends State<GraphicsPageScreen> {

  String currentDataSet = 'ai';
  String currentStyle = 'distribution';

  //TEMPORARY these values are here for testing purposes
  final List<PieChartSectionData> placeHolderData = [
    PieChartSectionData(value: 40, color: Colors.blue, title: 'A', radius: 120),
    PieChartSectionData(value: 30, color: Colors.red, title: 'B', radius: 120),
    PieChartSectionData(value: 20, color: Colors.green, title: 'C', radius: 120),
    PieChartSectionData(value: 10, color: Colors.orange, title: 'D', radius: 120),
  ];

  //TEMPORARY these values are here for testing purposes
  final List<FlSpot> placeHolderLineData = const [
    FlSpot(0, 80000),
    FlSpot(1, 95000),
    FlSpot(2, 110000),
    FlSpot(3, 105000),
    FlSpot(4, 130000),
    FlSpot(5, 145000),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.brightness == Brightness.light
                ? Colors.white
                : Colors.black,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Analytics",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: SingleChildScrollView(
          child:Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: "AI Careers",
                    style: currentDataSet == 'ai' ? 'primary' : 'secondary',
                    onPressed: () {
                      setState(() {
                        currentDataSet = 'ai';
                      });
                    },
                  ),
                  SizedBox(width:20),
                  CustomButton(
                    text: "Software Engineering", 
                    style: currentDataSet == 'se' ? 'primary' : 'secondary',
                    onPressed: () {
                      setState(() {
                        currentDataSet = 'se';
                      });
                    },
                  ),
                ],
              ),
              PieChartWidget(title: "Temporary", 
                  sections: placeHolderData,
                ),
            ],
          ),
        ),
      ),
    );
  }
}