import 'package:finalexam_salaries/model/ai_career_search_model.dart';
import '../model/graphics_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphicsPresenter {
  GraphicsModel model = GraphicsModel();
  List<AIJob>? AIJobs;

  GraphicsPresenter();

  //Get the data initially and store it in the presenter for all sorts of computations
  Future<void> fetchAIJobData() async {
    AIJobs ?? await model.getAIJobData();
  }

  //Group jobs by year
  Map<int, List<AIJob>> groupByYear(List<AIJob> jobs) {
    final Map<int, List<AIJob>> groupedJobs = {};

    for (final job in jobs) {
      groupedJobs.putIfAbsent(job.year, () => []).add(job);
    }
    //since jobs aren't sorted by year in the database, this sorts them
    return Map.fromEntries(
      groupedJobs.entries.toList()..sort((a,b) => a.key.compareTo(b.key)),
    );
  }

  //Group Jobs by other selectors, better for pie chart
  Map<String, List<AIJob>> groupByMetric(
    List<AIJob> jobs,
    String Function(AIJob) selector,
  ) {
    final Map<String, List<AIJob>> groupedJobs = {};
    for (final job in jobs) {
      groupedJobs.putIfAbsent(selector(job), () => []).add(job);
    }
    return groupedJobs;
  }

  //Getting averages, for trend graphs
  double getAverage(List<AIJob> jobs, double Function(AIJob) selector) {
    if (jobs.isEmpty) return 0;
    return jobs.map(selector).reduce((a,b) => a + b) / jobs.length;
  }

  //Building spots for line chart
  List<FlSpot> buildTrendSpots(
    List<AIJob> jobs,
    double Function(List<AIJob>) valueSelector,
  ) {
    final groupedJobs = groupByYear(jobs);
    double xIndex = 0;
    return groupedJobs.entries.map((entry) {
      return FlSpot(xIndex++, valueSelector(entry.value));
    }).toList();
  }

  //Build Sections for the pie chart
  List<PieChartSectionData> buildPieSections(
    List<AIJob> jobs,
    String Function(AIJob) groupSelector,
    double Function(List<AIJob>) valueSelector, {
      required List<Color> colors,
      double radius = 120,
    }
  ) {
    final groupedJobs = groupByMetric(jobs, groupSelector);
    final values = groupedJobs.map(
      (key, group) => MapEntry(key, valueSelector(group)),
    );
    final total = values.values.reduce((a,b) => a + b);
    int i = 0;
    return values.entries.map((entry) {
      final percent = (entry.value / total) * 100;
      return PieChartSectionData(
        value: percent,
        color: colors[i++ % colors.length],
        title: '${entry.key}\n${percent.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white
        )
      );
    }).toList();
  }

  //Returns a list of the sorted years, useful for line chart
  List<int> getSortedYears(List<AIJob> jobs) {
    return groupByYear(jobs).keys.toList();
  }
}