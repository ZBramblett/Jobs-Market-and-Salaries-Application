import 'package:finalexam_salaries/model/ai_career_search_model.dart';
import 'package:finalexam_salaries/presenter/graphics_presenter.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';
import 'package:finalexam_salaries/widgets/line_chart_widget.dart';
import 'package:finalexam_salaries/widgets/pie_chart_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphicsPageScreen extends StatefulWidget {
  const GraphicsPageScreen({super.key});

  @override
  State<GraphicsPageScreen> createState() => _GraphicsPageScreenState();
}

class _GraphicsPageScreenState extends State<GraphicsPageScreen> {

  final GraphicsPresenter _presenter = GraphicsPresenter();

  String currentDataSet = 'ai';
  String currentStyle = 'distribution';
  String currentMetric = 'experience';

  bool _isLoading = true;

  //Chart data
  List<PieChartSectionData> _pieSections = [];
  List<FlSpot> _lineSpots = [];
  List<int> _lineYearLabels = [];

  void _openFilterModal() {

    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterSheet(
        initialDataSet: currentDataSet, 
        initialStyle: currentStyle, 
        initialMetric: currentMetric, 
        onApply: (dataSet, style, metric) {
          setState(() {
            currentDataSet = dataSet;
            currentStyle = style;
            currentMetric = metric;
          });
          _rebuildChartData();
        }
      )
    );
  }

  String _yAxisLabel() {
    switch(currentMetric) {
      case 'salary':      return 'Avg. Salary';
      case 'experience' : return 'Experience';
      case 'education' :  return 'Education';
      case 'aiRiskCategory': return 'AI Risk Category';
      case 'primarySkill': return 'Primary Skill';
      case 'country' : return 'Country';
      case 'aiRiskScore': return 'Avg. Ai Risk Score';
      case 'skillDemand': return 'Avg. Skill Demand';
      case 'jobOpenings': return 'Avg. Job Openings';
      default:            return currentMetric;
    }
  }

  List<Color> _getColorsForPie() {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.onPrimary,
      colorScheme.onSecondary,
      ];
  }


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async{
    try {
      await _presenter.fetchAIJobData();
      _rebuildChartData();
    } catch(e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _rebuildChartData() {
    final jobs = _presenter.AIJobs;
    if(jobs == null || jobs.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final pieSections = _presenter.buildPieSections(
      jobs, 
      _groupSelectorForMetric(currentMetric), 
      _valueSelectorForMetric(currentMetric, jobs), 
      colors: _getColorsForPie()
      );
    
    final lineSpots = _presenter.buildTrendSpots(
      jobs, 
      _trendValueSelectorForMetric(currentMetric),
    );

    final yearLabels = _presenter.getSortedYears(jobs);

    setState(() {
      _pieSections = pieSections;
      _lineSpots = lineSpots;
      _lineYearLabels = yearLabels;
      _isLoading = false;
    });
  }

  //Metric to group pie chart
  String Function(AIJob) _groupSelectorForMetric(String metric) {
    switch (metric) {
      case 'experience': return (j) => j.experienceLevel;
      case 'education': return (j) => j.educationLevel;
      case 'aiRiskCategory': return (j) => j.aiRiskCategory;
      case 'primarySkill': return (j) => j.primarySkill;
      case 'country': return (j) => j.country;
      default: return (j) => j.experienceLevel;
    }
  }

  //Size of pie slice, will be increased if I add other metrics
  double Function(List<AIJob>) _valueSelectorForMetric(
    String metric, List<AIJob> jobs
  ) {
    switch (metric) {
      case 'experience':
      case 'education':
      case 'aiRiskCategory':
      case 'primarySkill':
      case 'country':
      default:  
          return (g) => g.length.toDouble();
    }
  }

  //Y-axis for line chart
  double Function(List<AIJob>) _trendValueSelectorForMetric(String metric) {
    switch(metric) {
      case 'salary': return (g) => _presenter.getAverage(g, (j) => j.salary);
      case 'aiRiskScore': return (g) => _presenter.getAverage(g, (j) => j.aiRiskScore);
      case 'skillDemand': return (g) => _presenter.getAverage(g, (j) => j.skillDemandScore.toDouble());
      case 'jobOpenings': return (g) => _presenter.getAverage(g, (j) => j.jobOpenings.toDouble());
      default: return (g) => _presenter.getAverage(g, (j) => j.salary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.brightness == Brightness.light
                ? Colors.white
                : Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          title: Text(
            "Analytics",
            style: TextStyle(color: colorScheme.onPrimary),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.tune, color: colorScheme.onPrimary),
              tooltip: "Filters",
              onPressed: _isLoading ? null : _openFilterModal,
            ),
          ],
        ),
        body: _buildBody(colorScheme),
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    if(_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                _SummaryChip(label: currentDataSet == 'ai' ? 'AI' : 'Software Engineering'),
                _SummaryChip(label: currentStyle == 'distribution' ? 'Distribution' : 'Trends'),
                _SummaryChip(label: _yAxisLabel()),
              ],
            ),
          ),
          const SizedBox(height: 8),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
            child: currentStyle == 'distribution'
                ? PieChartWidget(
                  title: "Job Distribution by $currentMetric", 
                  sections: _pieSections,
                 )
                : SizedBox(
                  height: 300,
                  child: LineChartWidget(
                    spots: _lineSpots, 
                    lineColor: colorScheme.primary, 
                    yAxisLabel: _yAxisLabel(), 
                    xAxisLabel: 'Year', 
                    bars: 1,
                    yearLabels: _lineYearLabels,
                    ),
                ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SheetSection extends StatelessWidget {
  final String label;
  final Map<String, String> options;
  final String selected;
  final ValueChanged<String> onChanged;
  final Set<String> disabledOptions;

  const _SheetSection({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.disabledOptions = const {},
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 0,
          runSpacing: 0,
          children: options.entries.map((entry) {
              final bool active = entry.key == selected;
              final bool disabled = disabledOptions.contains(entry.key);
              return Opacity(
                opacity: disabled ? 0.35 : 1.0,
                child: CustomButton(
                  text: entry.value,
                  style: active ? 'primary' : 'secondary',
                  width: 'fit', 
                  onPressed: disabled ? null : () => onChanged(entry.key),
                  ),
            );
          }).toList(),
        )
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  const _SummaryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: colorScheme.primary),
      side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final String initialDataSet;
  final String initialStyle;
  final String initialMetric;
  final void Function(String dataSet, String style, String metric) onApply;

  const _FilterSheet({
    required this.initialDataSet,
    required this.initialStyle,
    required this.initialMetric,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
      late String tempDataSet;
      late String tempStyle;
      late String tempMetric;

      static const _distributionOnlyMetrics = {
        'aiRiskCategory', 'primarySkill', 'country', 'experience', 'education'
      };

      static const _trendsOnlyMetrics = {
        'salary', 'aiRiskScore', 'skillDemand', 'jobOpenings'
      };

      @override
    void initState() {
      super.initState();
      tempDataSet = widget.initialDataSet;
      tempStyle = widget.initialStyle;
      tempMetric = widget.initialMetric;
    }

  @override
  Widget build(BuildContext context) {

    final Set<String> disabledMetrics = tempStyle == 'distribution'
      ? _trendsOnlyMetrics
      : _distributionOnlyMetrics;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Filters",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              _SheetSection(
                label: "Dataset", 
                options: const {
                  'ai' : 'AI Careers', 
                  'se': 'Software Engineering Careers'}, 
                selected: tempDataSet, 
                onChanged: (v) => setState(() {
                  tempDataSet = v;

                  if(v == 'se') {
                    tempStyle = 'distribution';
                    tempMetric = 'location';
                  } else {
                    tempStyle = 'distribution';
                    tempMetric = 'experience';
                  }
                }),
              ),
              const SizedBox(height: 20),
              _SheetSection(
                label: "Analytic", 
                options: const {
                  'distribution' : 'Job Distribution', 
                  'trends': 'Trends Over Time'}, 
                selected: tempStyle, 
                onChanged: (v) => setState(() {
                  tempStyle = v;
                  tempMetric = v == 'distribution' ? 'experience' : 'salary';
                }),
                disabledOptions: tempDataSet == 'se' ? const{'trends'} : const {},
              ),
              const SizedBox(height: 20),
                _SheetSection(
                  label: "Metric", 
                  options: tempDataSet == 'se'
                    ? const {
                      'location': 'Location',
                      'salaryRange': 'Salary Range',
                    }
                    : const {
                      'experience': 'Experience Level',
                      'education': 'Education Level',
                      'aiRiskCategory': 'AI Risk Category',
                      'primarySkill': 'Primary Skill',
                      'country': 'Country',
                      'salary': 'Avg. Salary',
                      'aiRiskScore': 'AI Risk Score',
                      'skillDemand': 'Skill Demand',
                      'jobOpenings': 'Job Openings',
                    } ,
                  selected: tempMetric, 
                  onChanged: (v) => setState(() => tempMetric = v),
                  disabledOptions: tempDataSet == 'se' ? const {} : disabledMetrics,
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: "Apply",
                  style: 'primary',
                  width: 'span', 
                  onPressed: () {
                    widget.onApply(tempDataSet,tempStyle, tempMetric);
                    Navigator.pop(context);
                    }
                  )
                ],
              ),
            );
  }

}