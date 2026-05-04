import 'package:finalexam_salaries/model/save_jobs.dart';
import 'package:finalexam_salaries/presenter/theme_presenter.dart';
import 'package:flutter/material.dart';
import '../model/salary_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<SalaryEntry> _results = [];
  bool _hasSearched = false;

  Future<void> _searchJobs() async {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    final model = SalaryModel();
    final jobs = await model.loadEntries();

    final filtered = jobs
        .where((job) => job.jobTitle.toLowerCase().contains(query))
        .toList();

    setState(() {
      _results = filtered;
      _hasSearched = true;
    });
  }

  String _formatSalary(SalaryEntry job) {
    if (job.salaryMin != null && job.salaryMax != null) {
      return '\$${job.salaryMin} - \$${job.salaryMax}';
    }
    return 'Salary N/A';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Software Engineer Job Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter job title',
                hintText: 'Example: Software Engineer',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchJobs(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _searchJobs, child: const Text('Search')),
            const SizedBox(height: 16),
            if (_hasSearched && _results.isEmpty)
              const Text('No jobs found. Try a different job title.'),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final job = _results[index];
                  return Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            themePresenter.BORDER_RADIUS.toDouble(),
                          ),
                        ),
                        child: ListTile(
                          title: Text(job.jobTitle),
                          subtitle: Text('${job.company}\n${job.location}'),
                          trailing: Text(_formatSalary(job)),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: StatefulBuilder(
                          builder: (context, setButtonState) {
                            final saved = SaveJobs.instance.isSavedSE(job);
                            return IconButton(
                              onPressed: () {
                                SaveJobs.instance.toggleSESave(job);
                                setButtonState(() {});
                              },
                              icon: Icon(
                                saved ? Icons.bookmark : Icons.bookmark_border,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
