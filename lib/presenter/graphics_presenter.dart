import 'package:finalexam_salaries/model/ai_career_search_model.dart';
import '../model/graphics_model.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphicsPresenter {
  GraphicsModel model = GraphicsModel();
  List<AIJob>? AIJobs;

  GraphicsPresenter();

  //Get the data initially and store it in the presenter for all sorts of computations
  Future<void> fetchAIJobData() async {
    AIJobs ?? await model.getAIJobData();
  }

  //Group jobs by year
  Map<int, List<AIJob>> groupByYear(List<AIJob> jobs) {
    final Map<int, List<AIJob>> groupedJobs = {};

    for (final job in jobs) {
      groupedJobs.putIfAbsent(job.year, () => []).add(job);
    }
    //since jobs aren't sorted by year in the database, this sorts them
    return Map.fromEntries(
      groupedJobs.entries.toList()..sort((a,b) => a.key.compareTo(b.key)),
    );
  }


}