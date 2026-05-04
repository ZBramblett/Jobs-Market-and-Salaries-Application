import 'package:finalexam_salaries/model/ai_career_search_model.dart';
import 'package:finalexam_salaries/model/salary_model.dart';
import 'package:finalexam_salaries/presenter/graphics_presenter.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';
import 'package:finalexam_salaries/widgets/bar_chart_widget.dart';
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
  List<BarChartGroupData> _barData = [];
  List<String> _barLabels = [];

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
      case 'salaryRange': return 'Salary Range';
      default:            return currentMetric;
    }
  }

  List<Color> _getColorsForPie() {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      Colors.greenAccent,
      Colors.teal,
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
      await _presenter.fetchSEJobData();
      _rebuildChartData();
    } catch(e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String Function(SalaryEntry) _seSelectorForMetric(String metric) {
    switch(metric) {
      case 'salaryRange': return (j) => _presenter.getSalaryBucket(j);
      default: return (j) => _presenter.getSalaryBucket(j);
    }
  }

  void _rebuildChartData() {
    if (currentDataSet == 'se') {
      final jobs = _presenter.seJobs;
      if (jobs == null || jobs.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }
      final pieSections = _presenter.buildPieSectionsSE(
        jobs,
        _seSelectorForMetric(currentMetric),
        colors: _getColorsForPie(),
      );
      setState(() {
        _pieSections = pieSections;
        _lineSpots = [];
        _lineYearLabels = [];
        _isLoading = false;
      });
      return;
    }

    if(currentDataSet == 'tracking') {
      final color = Theme.of(context).colorScheme.primary;
      setState(() {
        _barData = currentMetric == 'overview'
            ? _presenter.getApplicationOverviewBars(color)
            : _presenter.getConfidenceDistributionBars(color);
        _barLabels = currentMetric == 'overview'
          ? ['Saved', 'Applied', 'Interviews']
          : ['1', '2', '3', '4', '5'];
        _isLoading = false;
      });
      return;
    }

    final jobs = _presenter.AIJobs;
    if (jobs == null || jobs.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }
      final pieSections = _presenter.buildPieSections(
        jobs,
        _groupSelectorForMetric(currentMetric),
        _valueSelectorForMetric(currentMetric, jobs),
        colors: _getColorsForPie(),
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Current Filters",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                _SummaryChip(label: currentDataSet == 'ai' ? 'AI' : currentDataSet == 'se' ? 'Software Engineering': 'My Applications'),
                _SummaryChip(label: currentStyle == 'distribution' ? 'Distribution' : currentStyle == 'trends' ? 'Trends': 'Bar Char'),
                _SummaryChip(label: _yAxisLabel()),
              ],
            ),
          ),
          const SizedBox(height: 100),

          Center(
            child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
            child: currentDataSet == 'tracking'
                ? SizedBox(
                  height: 350,
                  child: BarChartWidget(
                    data: _barData, 
                    labels: _barLabels, 
                    title: currentMetric == 'overview'
                      ? 'Applications Overview'
                      : 'Confidence Distribution', 
                    yAxisLabel: 'Count'
                  ),
                )     
              :  currentStyle == 'distribution'
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
          ),
          const SizedBox(height: 32),
          Text(
            "Data taken from Kaggle Software Engineer Jobs & Salaries 2024 Dataset(courtesy of Emre Öksüz) and AI Job Impact & Salary Dataset (2015 - 2035) (courtesy of Shreyash Gade)",
            style: TextStyle(
              fontSize: 8,
              color: colorScheme.onSurface.withValues(alpha:0.4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Links: \nhttps://www.kaggle.com/datasets/emreksz/software-engineer-jobs-and-salaries-2024 \n https://www.kaggle.com/datasets/shree0910/ai-job-risk-and-salary-dataset-20152035?select=Future%20of%20Jobs%20AI%20Dataset.csv",
            style: TextStyle(
              fontSize: 8,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          )
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
                  'se': 'Software Engineering Careers',
                  'tracking': 'My Applications',
                  }, 
                selected: tempDataSet, 
                onChanged: (v) => setState(() {
                  tempDataSet = v;

                  if(v == 'se') {
                    tempStyle = 'distribution';
                    tempMetric = 'salaryRange';
                  }else if (v == 'tracking') {
                    tempStyle = 'bar';
                    tempMetric = 'overview';
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
                  'trends': 'Trends Over Time',
                  'bar': 'Bar Chart',
                  }, 
                selected: tempStyle, 
                onChanged: (v) => setState(() {
                  tempStyle = v;
                  tempMetric = v == 'distribution' ? 'experience' : 'salary';
                }),
                disabledOptions: tempDataSet == 'se' 
                    ? const{'trends', 'bar'}
                    : tempDataSet == 'tracking'
                      ? const {'distribution', 'trends'}
                      : const {'bar'}
              ),
              const SizedBox(height: 20),
                _SheetSection(
                  label: "Metric", 
                  options: tempDataSet == 'tracking'
                      ? const {
                        'overview': 'Application Overview',
                        'confidence': 'Confidence Distribtution',
                      }
                  
                 : tempDataSet == 'se'
                    ? const {
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
                  disabledOptions: tempDataSet == 'se' || tempDataSet == 'tracking' ? const {} : disabledMetrics,
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