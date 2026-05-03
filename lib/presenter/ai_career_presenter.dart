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
}