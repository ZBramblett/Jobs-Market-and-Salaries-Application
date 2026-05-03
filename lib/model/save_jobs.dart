import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_career_search_model.dart';
import 'package:table_calendar/table_calendar.dart';


class SaveJobs extends ChangeNotifier{
  SaveJobs._();

  static final SaveJobs instance = SaveJobs._();

  final List<AIJob> _savedJobsAI = [];
  final List<DateTime> _interviewDates = [];
  final Set<String> _savedAIIds = {};

  List<AIJob> get savedJobsAI => List.unmodifiable(_savedJobsAI);

  List<DateTime> get interviewDates => List.unmodifiable(_interviewDates);

  String getAIJobId(AIJob job) {
    return "${job.jobTitle}|${job.country}|${job.experienceLevel}|${job.educationLevel}|${job.year}|${job.salary}";
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_jobs', _savedAIIds.toList());
  }

  bool isSaved(AIJob job) {
    return _savedAIIds.contains(getAIJobId(job));
  }

  Future<void> loadSavedJobs(List<AIJob> allJobs) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('saved_jobs') ?? [];

    _savedAIIds.clear();
    _savedAIIds.addAll(savedIds);

    _savedJobsAI.clear();
    _savedJobsAI.addAll(
      allJobs.where((job) => _savedAIIds.contains(getAIJobId(job)))
    );

    notifyListeners();
  }

  void save(AIJob job) {
    final id = getAIJobId(job);

    if (!_savedAIIds.contains(id)) {
      _savedAIIds.add(id);
      _savedJobsAI.add(job);
      _persist();
      notifyListeners();
    }
  }

  void unsave(AIJob job) {
    final id = getAIJobId(job);

    if(_savedAIIds.contains(id)) {
      _savedAIIds.remove(id);
      _savedJobsAI.removeWhere((j) => getAIJobId(j) == id);
      _persist();
      notifyListeners();
    }
  }

  void toggle(AIJob job) {
    isSaved(job) ? unsave(job) : save(job);
  }

  void addInterviewDate(DateTime date) {
  if (!_interviewDates.any((d) => isSameDay(d, date))) {
    _interviewDates.add(date);
    notifyListeners();
    }
  }

  void removeInterviewDate(DateTime date) {
    _interviewDates.removeWhere((d) => isSameDay(d, date));
    notifyListeners();
  }
}