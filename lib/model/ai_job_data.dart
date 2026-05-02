import 'package:flutter/services.dart' show rootBundle;
import 'ai_career_search_model.dart';

class AIJobData {
  AIJobData._();
  static final AIJobData instance = AIJobData._();

  List<AIJob>? _cache;

  /// Loads and parses the CSV. Returns the cached list on subsequent calls.
  Future<List<AIJob>> loadJobs() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString('lib/data/cleaned_AI_data.csv');
    final lines = raw.split(RegExp(r'\r?\n'))
        .where((line) => line.trim().isNotEmpty)
        .toList();

    if (lines.length < 2) {
      _cache = [];
      return _cache!;
    }

    final jobs = <AIJob>[];
    for (var i = 1; i < lines.length; i++) {
      final cells = _splitCsvLine(lines[i]);
      if (cells.length < 13) continue; 
      try {
        jobs.add(AIJob.fromCsvRow(cells));
      } catch (_) {
      }
    }

    _cache = jobs;
    return _cache!;
  }

  List<String> _splitCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        inQuotes = !inQuotes;
      } else if (ch == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(ch);
      }
    }
    result.add(buffer.toString());
    return result;
  }

  // Query helpers used by the presenters

  /// Case-insensitive substring match on job_title.
  Future<List<AIJob>> searchByJobTitle(String query) async {
    final jobs = await loadJobs();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return jobs.where((j) => j.jobTitle.toLowerCase().contains(q)).toList();
  }

  /// All distinct job titles.
  Future<List<String>> distinctJobTitles() async {
    final jobs = await loadJobs();
    final titles = jobs.map((j) => j.jobTitle).toSet().toList();
    titles.sort();
    return titles;
  }

  /// All rows for a given job title.
  Future<List<AIJob>> jobsForTitle(String title) async {
    final jobs = await loadJobs();
    final t = title.trim().toLowerCase();
    return jobs.where((j) => j.jobTitle.toLowerCase() == t).toList();
  }
}