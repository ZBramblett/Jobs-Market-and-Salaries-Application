import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget{
  final List<BarChartGroupData> data;
  final List<String> labels;
  final String title;
  final String yAxisLabel;

  const BarChartWidget({
    super.key,
    required this.data,
    required this.labels,
    required this.title,
    required this.yAxisLabel
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(title),
          SizedBox(height: 10),
          Expanded(
            child:           BarChart(
            BarChartData(
              barGroups: data,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if(index < 0 || index >= labels.length) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          labels[index],
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(yAxisLabel),
                  sideTitles: const SideTitles(showTitles: true, reservedSize: 36),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
            )
          ),
          ),

        ],
      ),
    );
  }
}