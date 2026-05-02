import 'package:flutter/material.dart';
import '../presenter/salary_presenter.dart';
import '../presenter/theme_presenter.dart';
import 'UI_functions.dart';

class CityComparerScreen extends StatefulWidget {
  const CityComparerScreen({super.key});

  @override
  State<CityComparerScreen> createState() => _CityComparerScreenState();
}

class _CityComparerScreenState extends State<CityComparerScreen> {
  final _presenter = SalaryPresenter();
  final _searchController = TextEditingController();

  bool _loading = true;
  List<String> _filteredCities = [];
  final List<String> _selectedCities = [];
  final List<CityStats> _stats = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _presenter.loadData();
    setState(() {
      _loading = false;
      _filteredCities = _presenter.searchCities('');
    });
  }

  // Updates city list as the user types in the search field
  void _onSearchChanged() {
    setState(() {
      _filteredCities = _presenter.searchCities(_searchController.text);
    });
  }

  // Adds a city to the comparison and clears the search
  void _addCity(String city) {
    if (_selectedCities.contains(city)) return;
    final stats = _presenter.getStatsForCity(city);
    if (stats == null) return;
    setState(() {
      _selectedCities.add(city);
      _stats.add(stats);
      _searchController.clear();
    });
  }

  void _removeCity(String city) {
    setState(() {
      _stats.removeWhere((s) => s.city == city);
      _selectedCities.remove(city);
    });
  }

  // Formats a salary number as "$94K"
  String _fmt(num salary) => '\$${(salary / 1000).toStringAsFixed(0)}K';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = themePresenter.BORDER_RADIUS.toDouble();

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('City Salary Comparer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search cities to add...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: scheme.primary.withAlpha(125),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(border),
                  borderSide: BorderSide(color: scheme.onPrimary),
                ),
              ),
            ),
          ),

          if (_selectedCities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Wrap(
                spacing: 8,
                children: _selectedCities
                    .map((city) => Chip(
                          label: Text(city),
                          onDeleted: () => _removeCity(city),
                          backgroundColor: scheme.primary,
                          labelStyle: TextStyle(color: scheme.onPrimary),
                          deleteIconColor: scheme.onPrimary,
                        ))
                    .toList(),
              ),
            ),

          Expanded(
            child: _searchController.text.isNotEmpty
                ? _buildCityList(scheme)
                : _buildComparisonCards(scheme, border),
          ),
        ],
      ),
    );
  }

  Widget _buildCityList(ColorScheme scheme) {
    return ListView.builder(
      itemCount: _filteredCities.length,
      itemBuilder: (context, i) {
        final city = _filteredCities[i];
        final selected = _selectedCities.contains(city);
        return ListTile(
          title: Text(city),
          trailing: selected
              ? Icon(Icons.check, color: scheme.primary)
              : Icon(Icons.add, color: scheme.onSurface.withAlpha(150)),
          onTap: selected ? null : () => _addCity(city),
        );
      },
    );
  }

  static const _suggestedCities = [
    'New York, NY',
    'San Francisco, CA',
    'Seattle, WA',
    'Chicago, IL',
    'Los Angeles, CA',
    'Minneapolis, MN',
  ];


  Widget _buildComparisonCards(ColorScheme scheme, double border) {
    // Show suggested cities when nothing is selected yet
    if (_stats.isEmpty) {
      final suggestions = _suggestedCities
          .where((c) => !_selectedCities.contains(c) && _presenter.getStatsForCity(c) != null)
          .toList();

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Text(
            'Suggested Cities',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 2.1,
            children: suggestions
                .map((city) => CustomButton(
                      text: city.split(', ').first,
                      width: 'span',
                      onPressed: () => _addCity(city),
                    ))
                .toList(),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: _stats.map((s) => _buildCard(s, scheme, border)).toList(),
    );
  }

  Widget _buildCard(CityStats stats, ColorScheme scheme, double border) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stats.city,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              CustomButton(
                text: 'Remove',
                style: 'error',
                onPressed: () => _removeCity(stats.city),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statColumn('Avg Salary', _fmt(stats.avgSalary), scheme),
              _statColumn('Min', _fmt(stats.minSalary), scheme),
              _statColumn('Max', _fmt(stats.maxSalary), scheme),
              _statColumn('Listings', '${stats.listingCount}', scheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statColumn(String label, String value, ColorScheme scheme) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: scheme.onSurface)),
        Text(label,
            style: TextStyle(fontSize: 11, color: scheme.onSurface.withAlpha(150))),
      ],
    );
  }
}
