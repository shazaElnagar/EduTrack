import 'package:flutter/material.dart';


class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildTile(context, 'Manage TAs', Icons.people, ManageTAsScreen()),
          _buildTile(context, 'Manage Subjects', Icons.book, ManageSubjectsScreen()),
          _buildTile(context, 'Scan History', Icons.history, ScanHistoryScreen()),
          _buildTile(context, 'Send Notification', Icons.notifications, SendNotificationScreen()),
          _buildTile(context, 'Settings', Icons.settings, SettingScreen()),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, Widget screen) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        ),
      ),
    );
  }
}
class ManageTAsScreen extends StatefulWidget {
  @override
  State<ManageTAsScreen> createState() => _ManageTAsScreenState();
}

class _ManageTAsScreenState extends State<ManageTAsScreen> {
  final List<Map<String, String>> tas = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  void _addTA() {
    if (nameController.text.isNotEmpty && subjectController.text.isNotEmpty) {
      setState(() {
        tas.add({
          'name': nameController.text,
          'subject': subjectController.text,
        });
      });
      nameController.clear();
      subjectController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage TAs')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'TA Name'),
                ),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                ),
                ElevatedButton(onPressed: _addTA, child: Text('Add')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tas.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(tas[index]['name'] ?? ''),
                  subtitle: Text('Subject: ${tas[index]['subject']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ManageSubjectsScreen extends StatefulWidget {
  @override
  State<ManageSubjectsScreen> createState() => _ManageSubjectsScreenState();
}

class _ManageSubjectsScreenState extends State<ManageSubjectsScreen> {
  final List<String> subjects = [];
  final TextEditingController subjectController = TextEditingController();

  void _addSubject() {
    if (subjectController.text.isNotEmpty) {
      setState(() {
        subjects.add(subjectController.text);
      });
      subjectController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Subjects')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(labelText: 'Subject Name'),
                ),
                ElevatedButton(onPressed: _addSubject, child: Text('Add')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(subjects[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class ScanHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> scanHistory = [
    {'name': 'Ahmed', 'time': '10:30 AM'},
    {'name': 'Mona', 'time': '11:00 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan History')),
      body: ListView.builder(
        itemCount: scanHistory.length,
        itemBuilder: (_, index) {
          final entry = scanHistory[index];
          return ListTile(
            title: Text(entry['name']!),
            subtitle: Text('Time: ${entry['time']}'),
          );
        },
      ),
    );
  }
}
class SendNotificationScreen extends StatefulWidget {
  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final TextEditingController notificationController = TextEditingController();

  void _sendNotification() {
    final text = notificationController.text;
    if (text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification Sent: $text')),
      );
      notificationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Notification')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: notificationController,
              decoration: InputDecoration(labelText: 'Enter Notification Message'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _sendNotification,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
