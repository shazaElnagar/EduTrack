import 'package:flutter/material.dart';
import 'dart:math';



class StudentAttendance {
  final String name;
  final String id;
  final String section;
  final DateTime date;
  final bool attended;

  StudentAttendance({
    required this.name,
    required this.id,
    required this.section,
    required this.date,
    required this.attended,
  });
}

class AttendanceScreen extends StatelessWidget {
  final List<String> studentNames = [
    "Alice Johnson",
    "Bob Smith",
    "Charlie Evans",
    "Diana Patel",
    "Ethan Lee",
    "Fiona Gomez",
    "George Wu",
    "Hannah Kim"
  ];

  final List<String> sections = [
    "Section A",
    "Section B",
    "Section C",
    "Section D"
  ];

  List<StudentAttendance> generateAttendanceData() {
    final rand = Random();
    final today = DateTime.now();

    return List.generate(10, (index) {
      final name = studentNames[rand.nextInt(studentNames.length)];
      final id = 'ID:********${rand.nextInt(90) + 10}';
      final section = sections[rand.nextInt(sections.length)];
      final attended = rand.nextBool();

      return StudentAttendance(
        name: name,
        id: id,
        section: section,
        date: today,
        attended: attended,
      );
    });
  }

  String formatDate(DateTime date) {
    final months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    return "${months[date.month - 1]} ${date.day}/${date.year % 100}";
  }

  @override
  Widget build(BuildContext context) {
    final attendanceList = generateAttendanceData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005B7F),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const Text(
              "Attendance",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: attendanceList.length,
        itemBuilder: (context, index) {
          final item = attendanceList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatDate(item.date),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.id,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.section,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Text(
                            item.attended ? "Attended" : "Absent",
                            style: TextStyle(
                              color: item.attended ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            item.attended ? Icons.check_circle : Icons.cancel,
                            color: item.attended ? Colors.green : Colors.red,
                            size: 18,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}