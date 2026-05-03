import 'package:finalexam_salaries/view/graphics_page.dart';
import 'package:finalexam_salaries/widgets/interview_calendar.dart';
import 'package:finalexam_salaries/widgets/saved_jobs_widget.dart';
import 'package:flutter/material.dart';
import 'package:finalexam_salaries/model/save_jobs.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';
import '../presenter/auth_presenter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const GraphicsPageScreen()));
            }, 
            tooltip: 'Analytics',
            icon: const Icon(Icons.analytics))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const OverviewCard(),
            const SizedBox(height: 5),
            Text(
              "Interview Calendar",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            const InterviewCalendarWidget(),
            const SizedBox(height: 16),
            const SavedJobsList(),
          ],
        ),
      ),
    );
  }
}

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SaveJobs.instance, 
      builder: (context, _) {
        final saved = SaveJobs.instance.savedJobsAI.length;

        return _buildCard(context, saved);
      }
    );
  }

  Widget _buildCard(BuildContext context, int saved) {
    final colorScheme = Theme.of(context).colorScheme;
    final savedJobsAI = SaveJobs.instance.savedJobsAI;

    //temporary, will be replaced when software engineering search is implemented
    final int saved = savedJobsAI.length;
    final int applied = 0;
    final int interviews = 0;
    final int offers = 0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: colorScheme.primary.withValues(alpha: 0.3), width: 0.75)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Job Search Overview",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatCell(label: "Saved", value: saved, colorScheme: colorScheme),
              StatCell(label: "Applied", value: applied, colorScheme: colorScheme),
              StatCell(label: "Interviews", value: interviews, colorScheme: colorScheme),
              StatCell(label: "Offers", value: offers, colorScheme: colorScheme)
            ],
          )
        ],
      )
    );
  }
}

class StatCell extends StatelessWidget {
  final String label;
  final int value;
  final ColorScheme colorScheme;

  const StatCell({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

