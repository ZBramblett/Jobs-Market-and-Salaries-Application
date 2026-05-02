import '../model/salary_model.dart';

class CityStats {
  final String city;
  final double avgSalary;
  final int minSalary;
  final int maxSalary;
  final int listingCount;

  CityStats({
    required this.city,
    required this.avgSalary,
    required this.minSalary,
    required this.maxSalary,
    required this.listingCount,
  });
}

class SalaryPresenter {
  final SalaryModel _model = SalaryModel();
  List<SalaryEntry>? _entries;

  // Loads CSV data once and caches it
  Future<void> loadData() async {
    _entries ??= await _model.loadEntries();
  }

  // Returns sorted city list, filtered by query if provided
  List<String> searchCities(String query) {
    if (_entries == null) return [];
    final cities = _entries!.map((e) => e.location).toSet().toList()..sort();
    if (query.isEmpty) return cities;
    final q = query.toLowerCase();
    return cities.where((c) => c.toLowerCase().contains(q)).toList();
  }

  // Returns avg/min/max salary stats for a given city, or null if no data
  CityStats? getStatsForCity(String city) {
    if (_entries == null) return null;

    // Only include entries that have a valid salary range
    final cityEntries = _entries!
        .where((e) => e.location == city && e.salaryMid != null)
        .toList();

    if (cityEntries.isEmpty) return null;

    final mids = cityEntries.map((e) => e.salaryMid!).toList();
    final mins = cityEntries.map((e) => e.salaryMin!).toList();
    final maxs = cityEntries.map((e) => e.salaryMax!).toList();

    return CityStats(
      city: city,
      avgSalary: mids.reduce((a, b) => a + b) / mids.length,
      minSalary: mins.reduce((a, b) => a < b ? a : b),
      maxSalary: maxs.reduce((a, b) => a > b ? a : b),
      listingCount: cityEntries.length,
    );
  }
}
