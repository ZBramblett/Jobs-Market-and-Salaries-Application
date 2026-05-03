import 'package:finalexam_salaries/model/job_tracking_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_career_search_model.dart';
import 'salary_model.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';


class SaveJobs extends ChangeNotifier{
  SaveJobs._();

  static final SaveJobs instance = SaveJobs._();

  final List<AIJob> _savedJobsAI = [];
  final List<SalaryEntry> _savedJobsSE = [];
  final List<DateTime> _interviewDates = [];

  final Set<String> _savedAIIds = {};
  final Set<String> _savedSEIds = {};

  final Map<String, SEJobTracking> _seJobTracking = {};

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

    Future<void> loadSavedSEJobs(List<SalaryEntry> allSEJobs) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('saved_jobs_se') ?? [];

    _savedSEIds.clear();
    _savedSEIds.addAll(savedIds);

    _savedJobsSE.clear();
    _savedJobsSE.addAll(
      allSEJobs.where((job) => _savedSEIds.contains(getSEJobId(job)))
    );

    await _loadSETracking();
    notifyListeners();
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


  //Methods for tracking software jobs for use in the dashboard
  SEJobTracking getTrack(SalaryEntry job) {
    return _seJobTracking[getSEJobId(job)] ?? SEJobTracking();
  }

  Future<void> _persistSETracking() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _seJobTracking.map((id,t) => MapEntry(id,
        '${t.applied}|${t.hasInterview}|${t.interviewDate?.toIso8601String() ?? ''}|${t.confidenceRating}'
        ));
    await prefs.setString('se_tracking', jsonEncode(encoded));
  }

  void updateTracking(SalaryEntry job, SEJobTracking tracking) {
    _seJobTracking[getSEJobId(job)] = tracking;
    _persistSETracking();
    notifyListeners();
  }

  Future<void> _loadSETracking() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('se_tracking');
    if (raw == null) return;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    for (final entry in decoded.entries) {
      final parts = (entry.value as String).split('|');
      if (parts.length != 4) continue;
      _seJobTracking[entry.key] = SEJobTracking(
        applied:          parts[0] == 'true',
        hasInterview:     parts[1] == 'true',
        interviewDate:    parts[2].isNotEmpty ? DateTime.tryParse(parts[2]) : null,
        confidenceRating: int.tryParse(parts[3]) ?? 0,
      );
    }
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