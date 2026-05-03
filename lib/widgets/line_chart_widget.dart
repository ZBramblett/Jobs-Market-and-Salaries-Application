import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget{
  final List<FlSpot> spots;
  final Color lineColor;
  final String yAxisLabel;
  final String xAxisLabel;
  final int bars;
  final List<int> yearLabels;

  const LineChartWidget({
    super.key,
    required this.spots,
    required this.lineColor,
    required this.yAxisLabel,
    required this.xAxisLabel,
    required this.bars,
    required this.yearLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        duration: Duration(milliseconds: 300),
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  yAxisLabel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              sideTitles: const SideTitles(showTitles: false, reservedSize: 36),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(
                  xAxisLabel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= yearLabels.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      '${yearLabels[index]}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),

          minX: 0,
          maxX: spots.isEmpty ? 1 : spots.length.toDouble() - 1,

          minY: 0,
          maxY: spots.isEmpty ? 1 : spots.map((s) => s.y).reduce((a,b) => a > b ? a : b) * 1.2, //filler data, im not sure how i want to do this quite yet

          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: lineColor,
              barWidth: 5,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withValues(alpha:0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}