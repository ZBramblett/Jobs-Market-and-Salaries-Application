import 'package:finalexam_salaries/model/ai_career_search_model.dart';

import 'ai_job_data.dart';

//This is a pretty sparse file, mostly it just exists to load the ai job data. However, I wanted to keep it to try to adhere to MVP as much as possible

class GraphicsModel {
  GraphicsModel();

  Future <List<AIJob>> getAIJobData() async {
    return await AIJobData.instance.loadJobs();
  }
}