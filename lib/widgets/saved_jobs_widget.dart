import 'package:finalexam_salaries/model/job_tracking_model.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';
import 'package:flutter/material.dart';
import 'package:finalexam_salaries/model/ai_career_search_model.dart';
import 'package:finalexam_salaries/model/save_jobs.dart';
import 'package:finalexam_salaries/model/salary_model.dart';

class SavedJobsList extends StatefulWidget {
  const SavedJobsList({super.key});

  @override
  State<SavedJobsList> createState() => _SavedJobsListState();
}

class _SavedJobsListState extends State<SavedJobsList> {
  @override
  void initState() {
    super.initState();
    SaveJobs.instance.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    SaveJobs.instance.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() => setState(() { });

  void _openAIJobDetail(AIJob job) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AIJobDetailSheet(job: job)
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final aiJobs = SaveJobs.instance.savedJobsAI;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            "Saved Software Engineering Jobs",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        if (SaveJobs.instance.savedJobsSE.isEmpty)
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        "No saved software engineering jobs yet.",
        style: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
    ),
  )
else
  ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemCount: SaveJobs.instance.savedJobsSE.length,
    itemBuilder: (context, index) {
      final job = SaveJobs.instance.savedJobsSE[index];
      return _SEJobCard(job: job);
    },
  ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            "Saved AI Careers",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        if (aiJobs.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                "No saved AI jobs yet. Search for jobs and tap the bookmark icon to save them.",
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: aiJobs.length,
            itemBuilder: (context, index) {
              return _AIJobCard(
                job: aiJobs[index],
                onTap: () => _openAIJobDetail(aiJobs[index]),
              );
            },
          ),

        const SizedBox(height: 32),
      ],
    );
  }
}

class _AIJobCard extends StatelessWidget {
  final AIJob job;
  final VoidCallback onTap;

  const _AIJobCard({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
          border: Theme.of(context).brightness == Brightness.dark
              ? Border.all(color: colorScheme.primary.withValues(alpha:0.3), width: 0.75)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.jobTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.country,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${job.salary.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                _AIRiskBadge(score: job.aiRiskCategory, scheme: colorScheme),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AIRiskBadge extends StatelessWidget {
  final String score;
  final ColorScheme scheme;

  const _AIRiskBadge({required this.score, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label = score;

    switch(score) {
      case 'High Risk': color = Colors.red;
      case 'Medium Risk': color = Colors.orange;
      case 'Low Risk': color = Colors.green;
      default: color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _AIJobDetailSheet extends StatelessWidget {
  final AIJob job;

  const _AIJobDetailSheet({required this.job});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 2,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            job.jobTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            job.country,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: colorScheme.onSurface.withValues(alpha: 0.15)),
          const SizedBox(height: 12),

          _DetailRow(label: 'Salary', value: '\$${job.salary.toStringAsFixed(0)}', colorScheme: colorScheme),
          _DetailRow(label: 'Experience Level', value: job.experienceLevel, colorScheme: colorScheme),
          _DetailRow(label: 'Education Level', value: job.educationLevel, colorScheme: colorScheme),
          _DetailRow(label: 'Primary Skill', value: job.primarySkill, colorScheme: colorScheme),
          _DetailRow(label: 'Salary Bucket', value: job.salaryBucket, colorScheme: colorScheme),
          _DetailRow(label: 'AI Risk Score', value: job.aiRiskScore.toString(), colorScheme: colorScheme),
          _DetailRow(label: 'AI Risk Category', value: job.aiRiskCategory, colorScheme: colorScheme),
          _DetailRow(label: 'Skill Demand Score', value: job.skillDemandScore.toString(), colorScheme: colorScheme),
          _DetailRow(label: 'Job Openings', value: job.jobOpenings.toString(), colorScheme: colorScheme),
          _DetailRow(label: 'Survival Class', value: job.jobSurvivalClass.toString(), colorScheme: colorScheme),
          _DetailRow(label: 'Year', value: job.year.toString(), colorScheme: colorScheme),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.colorScheme
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _SEJobCard extends StatelessWidget {
  final SalaryEntry job;
  const _SEJobCard({required this.job});

  String _formatSalary() {
    if (job.salaryMin != null && job.salaryMax != null) {
      return '\$${job.salaryMin} - \$${job.salaryMax}';
    }
    return 'Salary N/A';
  }

  void _openTracker(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top:Radius.circular(20)),
      ),
      builder: (_) => _SETrackingSheet(job: job),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _openTracker(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(2,2),
            ),
          ],
          border: Theme.of(context).brightness == Brightness.dark
              ? Border.all(color: colorScheme.primary.withValues(alpha: 0.3), width: 0.75)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.jobTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.company,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    job.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _formatSalary(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            _TrackingIndicators(job: job),
          ],
        )
      )
    );
  }
}

class _TrackingIndicators extends StatelessWidget {
  final SalaryEntry job;
  const _TrackingIndicators({required this.job});

  @override
  Widget build(BuildContext context){
    final tracking = SaveJobs.instance.getTrack(job);
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        if(tracking.applied)
          Icon(Icons.check_circle, size: 16, color: Colors.green),
        if (tracking.hasInterview)
          Icon(Icons.calendar_today, size: 16, color: colorScheme.primary),
        if(tracking.confidenceRating > 0)
          Row(
            children: [
              const SizedBox(width: 4),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Text('${tracking.confidenceRating}',
              style: TextStyle(fontSize: 12, color: colorScheme.onSurface)),
            ],
          ),
      ],
    );
  }
}

class _SETrackingSheet extends StatefulWidget {
  final SalaryEntry job;
  const _SETrackingSheet({required this.job});

  @override
  State<_SETrackingSheet> createState() => _SETrackingSheetState();
}

class _SETrackingSheetState extends State<_SETrackingSheet> {
  late SEJobTracking _tracking;

  @override
  void initState() {
    super.initState();

    final t = SaveJobs.instance.getTrack(widget.job);
    _tracking = SEJobTracking(
      applied: t.applied,
      hasInterview: t.hasInterview,
      interviewDate: t.interviewDate,
      confidenceRating: t.confidenceRating,
    );
  }

  Future<void> _pickInterviewDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tracking.interviewDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if(picked != null) {
      setState(() => _tracking.interviewDate = picked);
      SaveJobs.instance.addInterviewDate(picked);
    }
  }

  void _save() {
    SaveJobs.instance.updateTracking(widget.job, _tracking);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32,),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            )
          ),
          const SizedBox(height: 20),

          Text(
            widget.job.jobTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            widget.job.company,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Applied',
                style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              ),
              Switch(
                value: _tracking.applied, 
                onChanged: (v) => setState(() => _tracking.applied = v),
                activeThumbColor: colorScheme.primary,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Interview?',
                style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              ),
              Switch(
                value: _tracking.hasInterview, 
                onChanged: (v) => setState(() {
                  _tracking.hasInterview = v;
                  if (!v) _tracking.interviewDate = null;
                }),
                activeThumbColor: colorScheme.primary,
              ),
            ],
          ),
          if(_tracking.hasInterview) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickInterviewDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: colorScheme.primary),
                    const SizedBox(width:12),
                    Text(
                      _tracking.interviewDate != null
                          ? '${_tracking.interviewDate!.month}/${_tracking.interviewDate!.day}/${_tracking.interviewDate!.year}'
                          : 'Pick interview date',
                      style: TextStyle(
                        fontSize: 15,
                        color: _tracking.interviewDate != null
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Confidence',
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final star = i + 1;
                return IconButton(
                  icon: Icon(
                    star <= _tracking.confidenceRating
                    ? Icons.star
                    : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () => setState(() => _tracking.confidenceRating = star),
                );
              }),
            ),
          ],

          const SizedBox(height: 24),
          CustomButton(
            text: 'Save',
            style: 'primary',
            width: 'span', 
            onPressed: _save
            )
        ],
      ),
    );
  }
}