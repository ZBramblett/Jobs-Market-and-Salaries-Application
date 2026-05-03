import 'package:finalexam_salaries/model/ai_career_search_model.dart';
import '../model/graphics_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finalexam_salaries/model/salary_model.dart';

class GraphicsPresenter {
  GraphicsModel model = GraphicsModel();
  List<AIJob>? AIJobs;
  List<SalaryEntry>? seJobs;

  GraphicsPresenter();

  //Get the data initially and store it in the presenter for all sorts of computations
  Future<void> fetchAIJobData() async {
    AIJobs ??= await model.getAIJobData();
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
          color: Colors.black
        )
      );
    }).toList();
  }

  //Returns a list of the sorted years, useful for line chart
  List<int> getSortedYears(List<AIJob> jobs) {
    return groupByYear(jobs).keys.toList();
  }

  //Fetch software jobs
  Future<void> fetchSEJobData() async {
    seJobs ??= await SalaryModel().loadEntries();
  }

  //Bucket salary into ranges (for graph purposes)
  String getSalaryBucket(SalaryEntry job) {
    final mid = job.salaryMid;
    if (mid == null) return 'Unknown';
    if (mid < 50000) return 'Under \$50k';
    if (mid < 100000) return '\$50k-\$100k';
    if (mid < 150000) return '\$100k-\$150k';
    return 'Over \$150k';
  }

  //Group se jobs by metric, similar to ai jobs
  Map<String, List<SalaryEntry>> groupSEByMetric(
    List<SalaryEntry> jobs,
    String Function(SalaryEntry) selector,
  ) {
    final Map<String, List<SalaryEntry>> grouped = {};
    for (final job in jobs) {
      grouped.putIfAbsent(selector(job), () => []).add(job);
    }
    return grouped;
  }

  List<PieChartSectionData> buildPieSectionsSE(
    List<SalaryEntry> jobs,
    String Function(SalaryEntry) groupSelector, {
      required List<Color> colors,
      double radius = 120,
      int topN = 8, //stops pie chart from having too many sections
    }) {
      final grouped = groupSEByMetric(jobs, groupSelector);

      grouped.removeWhere((key, _) => key =='Unknown');

      final sorted = grouped.entries.toList()..sort((a,b) => b.value.length.compareTo(a.value.length));
      final topEntries = sorted.take(topN).toList();
      final otherCount = sorted.skip(topN).fold(0, (sum,e) => sum + e.value.length);

      final total = jobs.length.toDouble();
      int i = 0;

      final sections = topEntries.map((entry) {
        final percent = (entry.value.length / total) * 100;
        return PieChartSectionData(
          value: percent,
          color: colors[i++ % colors.length],
          title: '${entry.key}\n${percent.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      }).toList();

      if (otherCount > 0) {
        final otherPercent = (otherCount / total) * 100;
        sections.add(PieChartSectionData(
          value: otherPercent,
          color: Colors.grey,
          title: 'Other\n${otherPercent.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
      }
      return sections;
    }
}