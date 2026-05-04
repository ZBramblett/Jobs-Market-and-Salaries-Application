import '../model/ai_career_search_model.dart';
import '../model/ai_job_data.dart';
import '../model/save_jobs.dart';

class AICareerPresenter {
  final AIJobData _data = AIJobData.instance;
  final SaveJobs _saved = SaveJobs.instance;

  Future<List<AIJob>> search(String query) async {
    return _data.searchByJobTitle(query);
  }

  bool isSaved(AIJob job) => _saved.isSaved(job);

  void toggleSave(AIJob job) => _saved.toggle(job);

  Future<Map<String, int>> getSkillDemand() async {
    final jobs = await _data.loadJobs();

    final Map<String, int> skillCounts = {};

    for (var job in jobs) {
      final skill = job.primarySkill.trim();
      final openings = job.jobOpenings;

      if (skill.isEmpty) continue;

      if (skillCounts.containsKey(skill)) {
        skillCounts[skill] = skillCounts[skill]! + openings;
      } else {
        skillCounts[skill] = openings;
      }
    }

    return skillCounts;
  }
}