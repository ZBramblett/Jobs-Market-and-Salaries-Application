import 'package:flutter/material.dart';
import '../model/ai_career_search_model.dart';
import '../presenter/ai_career_presenter.dart';
import '../presenter/theme_presenter.dart';
import 'UI_functions.dart';

class AICareerPage extends StatefulWidget {
  const AICareerPage({super.key});

  @override
  State<AICareerPage> createState() => _AICareerPageState();
}

class _AICareerPageState extends State<AICareerPage> {
  final AICareerPresenter _presenter = AICareerPresenter();
  final TextEditingController _searchController = TextEditingController();

  List<AIJob> _results = [];
  bool _hasSearched = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    themePresenter.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themePresenter.removeListener(_onThemeChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  Future<void> _runSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = true;
      });
      return;
    }
    setState(() => _loading = true);
    final results = await _presenter.search(query);
    if (!mounted) return;
    setState(() {
      _results = results;
      _hasSearched = true;
      _loading = false;
    });
  }

  String _formatSalary(double salary) {
    return '\$${salary.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(
      themePresenter.BORDER_RADIUS.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Career Search'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: Container(
        color: scheme.surface,
        child: Column(
          children: [
            // Search bar 
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _runSearch(),
                      decoration: InputDecoration(
                        hintText: 'Search a job title…',
                        filled: true,
                        fillColor: scheme.surface,
                        prefixIcon: Icon(Icons.search, color: scheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: radius,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(text: 'Search', onPressed: _runSearch),
                ],
              ),
            ),

            // Results 
            Expanded(
              child: _buildResults(scheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(ColorScheme scheme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Enter a job title above to see experience level, '
            'education requirement, and salary.',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurface, fontSize: 16),
          ),
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No matching jobs found.',
          style: TextStyle(color: scheme.onSurface, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final job = _results[index];
        final description =
            'Experience: ${job.experienceLevel}\n'
            'Education: ${job.educationLevel}\n'
            'Salary: ${_formatSalary(job.salary)}\n'
            'Country: ${job.country}';
        return Stack(
          children: [
            CustomCard(
              title: job.jobTitle,
              description: description,
            ),
            Positioned(
              top: 12,
              right: 12,
              child: StatefulBuilder(
                builder: (context, setButtonState) {
                  final saved = _presenter.isSaved(job);
                  return IconButton(
                    icon: Icon(
                      saved ? Icons.bookmark : Icons.bookmark_border,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      _presenter.toggleSave(job);
                      setButtonState(() {});
                    },
                  );
                }
              ),
            )
          ]
        );
      },
    );
  }
}