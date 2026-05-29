class PerformancePrediction {
  final int prediction;
  final int? predictedScore;
  final bool isPass;
  final DateTime generatedAt;

  PerformancePrediction({
    required this.prediction,
    this.predictedScore,
    required this.isPass,
    required this.generatedAt,
  });

  factory PerformancePrediction.fromJson(Map<String, dynamic> json) {
    return PerformancePrediction(
      prediction: json['prediction'] as int,
      predictedScore: json['predicted_score'] != null ? json['predicted_score'] as int : null,
      isPass: (json['prediction'] as int) == 1,
      generatedAt: DateTime.now(),
    );
  }
}

class StudentPerformanceData {
  final String gender;
  final String ethnicity;
  final String parentalLevelOfEducation;
  final String lunch;
  final String testPreparationCourse;
  final int mathScore;
  final int readingScore;
  final int writingScore;
  final double? studyHours;

  StudentPerformanceData({
    required this.gender,
    required this.ethnicity,
    required this.parentalLevelOfEducation,
    required this.lunch,
    required this.testPreparationCourse,
    required this.mathScore,
    required this.readingScore,
    required this.writingScore,
    this.studyHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'ethnicity': ethnicity,
      'parental_level_of_education': parentalLevelOfEducation,
      'lunch': lunch,
      'test_preparation_course': testPreparationCourse,
      'math_score': mathScore,
      'reading_score': readingScore,
      'writing_score': writingScore,
      if (studyHours != null) 'study_hours': studyHours,
    };
  }
}
