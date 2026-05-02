import 'package:flutter/material.dart';
import '../presenter/risk_analysis_presenter.dart';
import '../presenter/theme_presenter.dart';
import 'UI_functions.dart';

/// User picks a job title, show that job's average AI risk per region
class RiskAnalysisPage extends StatefulWidget {
  const RiskAnalysisPage({super.key});

  @override
  State<RiskAnalysisPage> createState() => _RiskAnalysisPageState();
}

class _RiskAnalysisPageState extends State<RiskAnalysisPage> {
  final RiskAnalysisPresenter _presenter = RiskAnalysisPresenter();

  List<String> _availableTitles = [];
  String? _selectedTitle;
  List<RegionRiskSummary> _summaries = [];
  bool _loadingTitles = true;
  bool _loadingResults = false;

  @override
  void initState() {
    super.initState();
    themePresenter.addListener(_onThemeChanged);
    _loadTitles();
  }

  @override
  void dispose() {
    themePresenter.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  Future<void> _loadTitles() async {
    final titles = await _presenter.availableJobTitles();
    if (!mounted) return;
    setState(() {
      _availableTitles = titles;
      _loadingTitles = false;
    });
  }

  Future<void> _runComparison() async {
    if (_selectedTitle == null) return;
    setState(() => _loadingResults = true);
    final summaries = await _presenter.compareByRegion(_selectedTitle!);
    if (!mounted) return;
    setState(() {
      _summaries = summaries;
      _loadingResults = false;
    });
  }

  Color _colorForCategory(String category, ColorScheme scheme) {
    switch (category) {
      case 'High Risk':
        return scheme.error;
      case 'Medium Risk':
        return scheme.tertiary;
      default:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(
      themePresenter.BORDER_RADIUS.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Analysis'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: themePresenter.getGradient(),
          ),
        ),
        child: Column(
          children: [
            //  Job title selector + compare button 
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _loadingTitles
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              borderRadius: radius,
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              hint: const Text('Select a job title…'),
                              value: _selectedTitle,
                              items: _availableTitles
                                  .map((t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(t),
                                      ))
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedTitle = value),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomButton(
                          text: 'Compare',
                          onPressed: _selectedTitle == null
                              ? null
                              : _runComparison,
                        ),
                      ],
                    ),
            ),

            // ----- Results -----
            Expanded(child: _buildResults(scheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(ColorScheme scheme) {
    if (_loadingResults) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_selectedTitle == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Pick a job title above to compare its AI risk score across '
            'world regions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurface, fontSize: 16),
          ),
        ),
      );
    }
    if (_summaries.isEmpty) {
      return Center(
        child: Text(
          'No data available for "$_selectedTitle".',
          style: TextStyle(color: scheme.onSurface, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _summaries.length,
      itemBuilder: (context, index) {
        final summary = _summaries[index];
        final pct = (summary.averageRiskScore * 100).toStringAsFixed(1);
        final description =
            'Avg AI Risk Score: ${summary.averageRiskScore.toStringAsFixed(2)} '
            '($pct%)\n'
            'Category: ${summary.riskCategory}\n'
            'Sample size: ${summary.sampleSize} job(s)';
        final categoryColor =
            _colorForCategory(summary.riskCategory, scheme);
        return Stack(
          children: [
            CustomCard(
              title: '#${index + 1}  ${summary.region}',
              description: description,
            ),
            // Small color pill indicating the risk category.
            Positioned(
              right: 24,
              top: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(
                    themePresenter.BORDER_RADIUS.toDouble(),
                  ),
                ),
                child: Text(
                  summary.riskCategory,
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}