import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_career_search_model.dart';
import 'salary_model.dart';
import 'package:table_calendar/table_calendar.dart';


class SaveJobs extends ChangeNotifier{
  SaveJobs._();

  static final SaveJobs instance = SaveJobs._();

  final List<AIJob> _savedJobsAI = [];
  final List<SalaryEntry> _savedJobsSE = [];
  final List<DateTime> _interviewDates = [];
  final Set<String> _savedAIIds = {};
  final Set<String> _savedSEIds = {};

  List<AIJob> get savedJobsAI => List.unmodifiable(_savedJobsAI);
  List<SalaryEntry> get savedJobsSE => List.unmodifiable(_savedJobsSE);
  List<DateTime> get interviewDates => List.unmodifiable(_interviewDates);


  //A bunch of methods for dealing with the AI database, unfortunately I'm running out of time and don't want to refactor everything to handle both types
  //of jobs, especially since they're both implemented slightly differently
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

  //A bunch of methods for dealing with software engineering database, it pains me to repeat myself but I just don't have time
  String getSEJobId(SalaryEntry job) {
    return "${job.jobTitle}|${job.company}|${job.location}";
  }

  Future<void> _persistSE() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_jobs_se', _savedSEIds.toList());
  }

  bool isSavedSE(SalaryEntry job) => _savedSEIds.contains(getSEJobId(job));

  void saveSE(SalaryEntry job) {
    final id = getSEJobId(job);
    if(!_savedSEIds.contains(id)) {
      _savedSEIds.add(id);
      _savedJobsSE.add(job);
      _persistSE();
      notifyListeners();
    }
  }

  void unsaveSE(SalaryEntry job) {
    final id = getSEJobId(job);
    if(_savedSEIds.contains(id)) {
      _savedSEIds.remove(id);
      _savedJobsSE.removeWhere((j) => getSEJobId(j) == id);
      _persistSE();
      notifyListeners();
    }
  }

  void toggleSESave(SalaryEntry job) => isSavedSE(job) ? unsaveSE(job) : saveSE(job);


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