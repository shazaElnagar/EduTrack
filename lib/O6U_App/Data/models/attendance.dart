 class Attendance {
  final int studentCode;
  final int section;
  final String name;
  final int lectureId;
  final String attendanceDate;

  Attendance({
    required this.studentCode,
    required this.section,
    required this.name,
    required this.lectureId,
    required this.attendanceDate,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      studentCode: json['studentId'] as int,
      section: json['section'] as int,
      name: json['name'] as String,
      lectureId: json['lectureId'] as int,
      attendanceDate: json['attendanceDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentCode,
      'section': section,
      'name': name,
      'lectureId': lectureId,
      'attendanceDate': attendanceDate,
    };
  }
  @override
  String toString() {
    return 'Attendance($studentCode,$section,$name,$lectureId,$attendanceDate)';
  }
}