class QuizDegree {
  final int studentCode;
  final String studentName;
  final int quizCode;
  final double degree;

  QuizDegree({
    required this.studentCode,
    required this.studentName,
    required this.quizCode,
    required this.degree,
  });

  factory QuizDegree.fromJson(Map<String, dynamic> json) {
    return QuizDegree(
      studentCode: json['StudentCode'],
      studentName: json['StudentName'],
      quizCode: json['QuizCode'],
      degree: (json['Degree'] is String)
          ? double.tryParse(json['Degree']) ?? 0.0
          : (json['Degree']?.toDouble() ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StudentCode': studentCode,
      'StudentName': studentName,
      'QuizCode': quizCode,
      'Degree': degree,
    };
  }
}