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

  String currentDataSet = 'ai';
  String currentStyle = 'distribution';
  String currentMetric = 'salary';

  //TEMPORARY these values are here for testing purposes
  final List<PieChartSectionData> placeHolderData = [
    PieChartSectionData(value: 40, color: Colors.blue, title: 'A', radius: 120),
    PieChartSectionData(value: 30, color: Colors.red, title: 'B', radius: 120),
    PieChartSectionData(value: 20, color: Colors.green, title: 'C', radius: 120),
    PieChartSectionData(value: 10, color: Colors.orange, title: 'D', radius: 120),
  ];

  //TEMPORARY these values are here for testing purposes
  final List<FlSpot> placeHolderLineData = const [
    FlSpot(0, 80000),
    FlSpot(1, 95000),
    FlSpot(2, 110000),
    FlSpot(3, 105000),
    FlSpot(4, 130000),
    FlSpot(5, 145000),
  ];

  void _openFilterModal() {
    String tempDataSet = currentDataSet;
    String tempStyle = currentStyle;
    String tempMetric = currentMetric;

    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                    onChanged: (v) => setSheetState(() => tempDataSet = v),
                  ),
                  const SizedBox(height: 20),
                  _SheetSection(
                    label: "Analytic", 
                    options: const {
                      'distribution' : 'Job Distribution', 
                      'trends': 'Trends Over Time'}, 
                    selected: tempStyle, 
                    onChanged: (v) => setSheetState(() => tempStyle = v),
                  ),
                  const SizedBox(height: 20),
                    _SheetSection(
                      label: "Metric", 
                      options: const {
                        'salary' : 'Salary', 
                        'experience': 'Experience Level',
                        'education' : 'Education Level'}, 
                      selected: tempMetric, 
                      onChanged: (v) => setSheetState(() => tempMetric = v),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: "Apply",
                    style: 'primary',
                    width: 'span', 
                    onPressed: () {
                      setState(() {
                        currentDataSet = tempDataSet;
                        currentStyle = tempStyle;
                        currentMetric = tempMetric;
                      });
                      Navigator.pop(context);
                    }
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _metricLabel(String metric) {
    switch(metric) {
      case 'salary':      return 'Salary';
      case 'experience' : return 'Experience';
      case 'education' :  return 'Education';
      default:            return metric;
    }
  }

  @override
  void initState() {
    super.initState();
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
              onPressed: _openFilterModal,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child:Column(
            children: [
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _SummaryChip(label: currentDataSet == 'ai' ? 'AI' : 'Software Eng.'),
                    _SummaryChip(label: currentStyle == 'distribution' ? 'Distribution' : 'Trends'),
                    _SummaryChip(label: _metricLabel(currentMetric)),
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
                      title: "Job Distribution by ${_metricLabel(currentMetric)}", 
                      sections: placeHolderData,
                )
                : SizedBox(
                  height: 300,
                  child: LineChartWidget(
                    spots: placeHolderLineData, 
                    lineColor: colorScheme.primary,
                    yAxisLabel: _metricLabel(currentMetric), 
                    xAxisLabel: 'Year', 
                    bars: 1),
                ),
              ),
              const SizedBox(height: 32),
           ],
          ),
        ),
      ),
    );
  }
}

class _SheetSection extends StatelessWidget {
  final String label;
  final Map<String, String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  const _SheetSection({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
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
              return CustomButton(
                text: entry.value, 
                style: active ? 'primary' : 'secondary',
                width: 'fit',
                onPressed: () => onChanged(entry.key),
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