
class SEJobTracking {
  bool applied;
  bool hasInterview;
  DateTime? interviewDate;
  int confidenceRating; // 1-5

  SEJobTracking({
    this.applied = false,
    this.hasInterview = false,
    this.interviewDate,
    this.confidenceRating = 0,
  });
}