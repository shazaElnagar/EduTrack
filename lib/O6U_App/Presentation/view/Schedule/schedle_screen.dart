import 'package:flutter/material.dart';
import 'dart:math';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> subjects = [
    'Mathematics', 'Physics', 'Chemistry',
    'Computer Science'
  ];

  late final List<Map<String, dynamic>> classes;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Sun'];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    // Generate classes
    Random random = Random();
    classes = List.generate(20, (index) {
      return {
        'subject': subjects[random.nextInt(subjects.length)],
        'day': random.nextInt(5), // 0 - 4
        'time': 8 + random.nextInt(8) // 8 to 15
      };
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // Convert time to AM/PM format
  String formatTime(int hour) {
    return hour < 12
        ? '$hour:00 AM'
        : (hour == 12 ? '12:00 PM' : '${hour - 12}:00 PM');
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF005B7F),
        title: Text(
          'Schedule',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: days.map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                    ),
                  ),
                ),
              )).toList(),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 8, // 8 rows (for hours 8:00 to 3:00)
                itemBuilder: (context, index) {
                  int hour = 8 + index;
                  return Row(
                    children: [
                      // Hour labels with AM/PM format
                      Container(
                        width: 60, // Fixed width for the hour label
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          formatTime(hour),
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Class schedule aligned under each day
                      ...List.generate(days.length, (dayIndex) {
                        Map<String, dynamic>? matchingClass = classes.firstWhere(
                              (cls) => cls['day'] == dayIndex && cls['time'] == hour,
                          orElse: () => {},
                        );

                        bool hasClass = matchingClass.isNotEmpty;

                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.all(2),
                            child: hasClass
                                ? FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(4),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        matchingClass['subject'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.025,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Text(
                                        'SEC',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.025,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                                : Container(),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}