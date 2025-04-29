import 'dart:math';
import 'package:flutter/material.dart';



/// Monitoring Main Screen
class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  bool sectionsExpanded = true;
  bool monitoringExpanded = true;

  final List<String> subjects = [
    'Data Structures', 'Operating Systems', 'Database Systems',
    'Computer Networks', 'Artificial Intelligence', 'Software Engineering',
    'Cybersecurity', 'Machine Learning', 'Mobile App Development',
    'Cloud Computing', 'Web Development', 'Computer Architecture'
  ];

  final List<String> times = [
    '08:00 AM', '09:30 AM', '11:00 AM', '01:15 PM', '03:45 PM', '05:00 PM'
  ];

  final Random random = Random();

  String getRandomSubject() => subjects[random.nextInt(subjects.length)];
  String getRandomTime() => times[random.nextInt(times.length)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: const Text(
          'Monitoring',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF005B7F),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {}); // Refresh to get new random items
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildExpandableSection(
              title: 'Sections',
              isExpanded: sectionsExpanded,
              onPressed: () {
                setState(() {
                  sectionsExpanded = !sectionsExpanded;
                });
              },
              cardColor: Colors.blue.shade800,
            ),
            const SizedBox(height: 24),
            buildExpandableSection(
              title: 'Monitoring',
              isExpanded: monitoringExpanded,
              onPressed: () {
                setState(() {
                  monitoringExpanded = !monitoringExpanded;
                });
              },
              cardColor: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }

  /// Build an expandable section (Sections / Monitoring)
  Widget buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onPressed,
    required Color cardColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 26,
                color: Colors.black,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (isExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return MonitoringCard(
                subject: getRandomSubject(),
                college: 'College of Computer Science',
                time: getRandomTime(),
                color: cardColor,
              );
            },
          ),
      ],
    );
  }
}

/// Single Card Widget
class MonitoringCard extends StatelessWidget {
  final String subject;
  final String college;
  final String time;
  final Color color;

  const MonitoringCard({
    Key? key,
    required this.subject,
    required this.college,
    required this.time,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Clicked on $subject'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              subject,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        title: Text(
          college,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        trailing: Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}