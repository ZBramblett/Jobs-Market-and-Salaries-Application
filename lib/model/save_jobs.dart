import 'package:flutter/material.dart';

import 'ai_career_search_model.dart';
import 'package:table_calendar/table_calendar.dart';

class SaveJobs extends ChangeNotifier{
  SaveJobs._();

  static final SaveJobs instance = SaveJobs._();

  final List<AIJob> _savedJobsAI = [];
  final List<DateTime> _interviewDates = [];

  List<AIJob> get savedJobsAI => List.unmodifiable(_savedJobsAI);

  List<DateTime> get interviewDates => List.unmodifiable(_interviewDates);

  bool isSaved(AIJob job) => _savedJobsAI.any((j) => 
    j.jobTitle == job.jobTitle && 
    j.country == job.country &&
    j.experienceLevel == job.experienceLevel &&
    j.educationLevel == job.educationLevel &&
    j.year == job.year &&
    j.salary == job.salary
  );

  void save(AIJob job) {
    if(!isSaved(job)){
      _savedJobsAI.add(job);
      notifyListeners();
    } 
  }

  void unsave(AIJob job) {
    _savedJobsAI.removeWhere((j) =>
      j.jobTitle == job.jobTitle &&
      j.country == job.country &&
      j.experienceLevel == job.experienceLevel &&
      j.educationLevel == job.educationLevel && 
      j.year == job.year &&
      j.salary == job.salary
    );
    notifyListeners();
  }

  void toggle(AIJob job) {
    isSaved(job) ? unsave(job) : save(job);
  }

  void addInterviewDate(DateTime date) {
  if (!_interviewDates.any((d) => isSameDay(d, date))) {
    _interviewDates.add(date);
    }
  }

  void removeInterviewDate(DateTime date) {
    _interviewDates.removeWhere((d) => isSameDay(d, date));
  }
}