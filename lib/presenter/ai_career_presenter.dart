import '../model/ai_career_search_model.dart';
import '../model/ai_job_data.dart';

class AICareerPresenter {
  final AIJobData _data = AIJobData.instance;

  Future<List<AIJob>> search(String query) async {
    return _data.searchByJobTitle(query);
  }

  Future<Map<String, int>> getSkillDemand() async {
    final jobs = await _data.loadJobs();

    final Map<String, int> skillCounts = {};

    for (var job in jobs) {
      final skill = job.primarySkill.trim();
      final openings = job.jobOpenings;

      if (skill.isEmpty) continue;

      if(skillCounts.containsKey(skill)) {
        skillCounts[skill] = skillCounts[skill]! + openings;
      } else {
        skillCounts[skill] = openings;
      
      }
    }

    return skillCounts;
  }
}