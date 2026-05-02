import 'package:finalexam_salaries/model/ai_career_search_model.dart';
import '../model/graphics_model.dart';

class GraphicsPresenter {
  GraphicsModel model = GraphicsModel();
  List<AIJob>? AIJobs;

  GraphicsPresenter();

  //Get the data initially and store it in the presenter for all sorts of computations
  Future<void> fetchAIJobData() async {
    AIJobs ?? await model.getAIJobData();
  }

  //Method to build line chart

  //Method to build pie chart

  //Method to build bar chart

  //trends over time

  //attribute comparison

  //job distribution methods, these will deal with creating the pie chart graphs in the view

}