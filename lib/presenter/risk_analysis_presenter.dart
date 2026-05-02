import '../model/ai_job_data.dart';
import '../model/region_mapper.dart';

class RegionRiskSummary {
  final String region;
  final double averageRiskScore;
  final int sampleSize;

  const RegionRiskSummary({
    required this.region,
    required this.averageRiskScore,
    required this.sampleSize,
  });

  String get riskCategory {
    if (averageRiskScore < 0.34) return 'Low Risk';
    if (averageRiskScore < 0.67) return 'Medium Risk';
    return 'High Risk';
  }
}

class RiskAnalysisPresenter {
  final AIJobData _data = AIJobData.instance;

  Future<List<String>> availableJobTitles() => _data.distinctJobTitles();

  /// For each job, group all matching rows by region, average the AI risk
  /// score per region, and return the summaries sorted from highest risk to lowest
  Future<List<RegionRiskSummary>> compareByRegion(String jobTitle) async {
    final rows = await _data.jobsForTitle(jobTitle);
    if (rows.isEmpty) return [];

    final byRegion = <String, List<double>>{};
    for (final job in rows) {
      final region = RegionMapper.regionFor(job.country);
      byRegion.putIfAbsent(region, () => []).add(job.aiRiskScore);
    }

    final summaries = byRegion.entries.map((entry) {
      final scores = entry.value;
      final avg = scores.reduce((a, b) => a + b) / scores.length;
      return RegionRiskSummary(
        region: entry.key,
        averageRiskScore: avg,
        sampleSize: scores.length,
      );
    }).toList();

    summaries.sort(
      (a, b) => b.averageRiskScore.compareTo(a.averageRiskScore),
    );
    return summaries;
  }
}