import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class SalaryEntry {
  final String company;
  final double companyScore;
  final String jobTitle;
  final String location;
  final int? salaryMin;
  final int? salaryMax;

  SalaryEntry({
    required this.company,
    required this.companyScore,
    required this.jobTitle,
    required this.location,
    this.salaryMin,
    this.salaryMax,
  });

  int? get salaryMid => (salaryMin != null && salaryMax != null)
      ? ((salaryMin! + salaryMax!) ~/ 2)
      : null;
}

// Converts "$94K" to 94000
int? _parseValue(String s) {
  final val = int.tryParse(s.replaceAll(RegExp(r'[$K\s]'), ''));
  return val != null ? val * 1000 : null;
}

// Splits "$68K - $94K (Glassdoor est.)" into [68000, 94000]
List<int?> _parseSalaryRange(String salary) {
  final parts = salary.replaceAll(RegExp(r'\(.*?\)'), '').trim().split(' - ');
  if (parts.length != 2) return [null, null];
  return [_parseValue(parts[0]), _parseValue(parts[1])];
}

class SalaryModel {
  Future<List<SalaryEntry>> loadEntries() async {
    final raw = await rootBundle.loadString('lib/data/cleaned_swe_data.csv');
    final rows = const CsvToListConverter().convert(raw, eol: '\n');

    final entries = <SalaryEntry>[];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 6) continue;

      final location = row[3].toString().trim();
      if (location.isEmpty || location == 'Remote') continue;

      final range = _parseSalaryRange(row[5].toString());

      entries.add(SalaryEntry(
        company: row[0].toString(),
        companyScore: double.tryParse(row[1].toString()) ?? 0.0,
        jobTitle: row[2].toString(),
        location: location,
        salaryMin: range[0],
        salaryMax: range[1],
      ));
    }
    return entries;
  }
}
