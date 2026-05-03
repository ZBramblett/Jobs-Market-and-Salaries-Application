import 'ai_career_search_model.dart';

class SaveJobs {
  SaveJobs._();

  static final SaveJobs instance = SaveJobs._();

  final List<AIJob> _savedJobs = [];

  List<AIJob> get savedJobs => List.unmodifiable(_savedJobs);

  bool isSaved(AIJob job) => _savedJobs.any((j) => 
    j.jobTitle == job.jobTitle && 
    j.country == job.country &&
    j.experienceLevel == job.experienceLevel &&
    j.educationLevel == job.educationLevel &&
    j.year == job.year &&
    j.salary == job.salary
  );

  void save(AIJob job) {
    if(!isSaved(job)) _savedJobs.add(job);
  }

  void unsave(AIJob job) {
    _savedJobs.removeWhere((j) =>
      j.jobTitle == job.jobTitle &&
      j.country == job.country &&
      j.experienceLevel == job.experienceLevel &&
      j.educationLevel == job.educationLevel && 
      j.year == job.year &&
      j.salary == job.salary
    );
  }

  void toggle(AIJob job) {
    isSaved(job) ? unsave(job) : save(job);
  }
}