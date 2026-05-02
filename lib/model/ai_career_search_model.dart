class AIJob {
  final String jobTitle;
  final String country;
  final String experienceLevel;
  final String educationLevel;
  final int year;
  final double salary;
  final double aiRiskScore;
  final String primarySkill;
  final int skillDemandScore;
  final int jobOpenings;
  final int jobSurvivalClass;
  final String salaryBucket;
  final String aiRiskCategory;

  const AIJob({
    required this.jobTitle,
    required this.country,
    required this.experienceLevel,
    required this.educationLevel,
    required this.year,
    required this.salary,
    required this.aiRiskScore,
    required this.primarySkill,
    required this.skillDemandScore,
    required this.jobOpenings,
    required this.jobSurvivalClass,
    required this.salaryBucket,
    required this.aiRiskCategory,
  });

  // Build an AIJob from a CSV row
  factory AIJob.fromCsvRow(List<String> row) {
    return AIJob(
      jobTitle: row[0].trim(),
      country: row[1].trim(),
      experienceLevel: row[2].trim(),
      educationLevel: row[3].trim(),
      year: int.tryParse(row[4].trim()) ?? 0,
      salary: double.tryParse(row[5].trim()) ?? 0.0,
      aiRiskScore: double.tryParse(row[6].trim()) ?? 0.0,
      primarySkill: row[7].trim(),
      skillDemandScore: int.tryParse(row[8].trim()) ?? 0,
      jobOpenings: int.tryParse(row[9].trim()) ?? 0,
      jobSurvivalClass: int.tryParse(row[10].trim()) ?? 0,
      salaryBucket: row[11].trim(),
      aiRiskCategory: row[12].trim(),
    );
  }
}