import '../model/ai_career_search_model.dart';
import '../model/ai_job_data.dart';

class AICareerPresenter {
  final AIJobData _data = AIJobData.instance;

  Future<List<AIJob>> search(String query) async {
    return _data.searchByJobTitle(query);
  }
}