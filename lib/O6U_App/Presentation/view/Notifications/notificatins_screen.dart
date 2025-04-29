import 'package:flutter/material.dart';
import 'dart:math';


class NotificationModel {
  final String message;
  final DateTime time;
  final String location;

  NotificationModel({
    required this.message,
    required this.time,
    required this.location,
  });
}

class NotificationScreen extends StatelessWidget {
  final List<String> sampleMessages = [
    "You have a monitoring tomorrow morning.",
    "You have a monitoring today morning.",
    "You have a section now.",
    "Dont forget monitoring today ",
  ];

  final List<String> sampleLocations = [
    "216 SS",
    "Room 101",
    "Office 2F",

  ];

  List<NotificationModel> generateNotifications() {
    final rand = Random();
    final now = DateTime.now();

    return List.generate(10, (index) {
      int dayOffset = rand.nextInt(5); // 0 = today, up to 4 days ago
      DateTime date = now.subtract(Duration(days: dayOffset));
      int hour = rand.nextInt(24);
      int minute = rand.nextInt(60);
      DateTime finalTime = DateTime(date.year, date.month, date.day, hour, minute);

      String location = sampleLocations[rand.nextInt(sampleLocations.length)];
      String message = sampleMessages[rand.nextInt(sampleMessages.length)];

      return NotificationModel(
        message: message,
        time: finalTime,
        location: location,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = generateNotifications();
    final now = DateTime.now();

    final todayNotifications = notifications.where((n) =>
    n.time.year == now.year &&
        n.time.month == now.month &&
        n.time.day == now.day).toList();

    final previousNotifications = notifications.where((n) =>
        n.time.isBefore(DateTime(now.year, now.month, now.day))).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF005B7F),
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
            Text(
              "Notifications",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (todayNotifications.isNotEmpty)
              sectionTitle("Today"),
            ...todayNotifications.map(notificationTile).toList(),
            if (previousNotifications.isNotEmpty)
              sectionTitle("Previous"),
            ...previousNotifications.map(notificationTile).toList(),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget notificationTile(NotificationModel notification) {
    final time = notification.time;
    final timeFormatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.message,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Time: $timeFormatted',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(width: 16),
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Location: ${notification.location}',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}