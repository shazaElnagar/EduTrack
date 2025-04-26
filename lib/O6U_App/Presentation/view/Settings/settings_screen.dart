import 'package:flutter/material.dart';



// Settings Screen
class SettingsScreen extends StatelessWidget {
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToEditInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditInformationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade400,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 16),
                Text(
                  'TA Full Name',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            buildOptionRow(
              context,
              'Edit your information',
              Icons.edit,
              onTap: () => _navigateToEditInfo(context),
            ),
            SizedBox(height: 16),
            buildOptionRow(
              context,
              'Log out',
              Icons.logout,
              onTap: () => _showSnackBar(context, 'Logged out successfully'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _showSnackBar(context, 'Account deleted successfully');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  Icon(Icons.delete, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionRow(BuildContext context, String title, IconData icon,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          Icon(icon, color: Colors.black),
        ],
      ),
    );
  }
}

// Dummy Edit Information Screen
class EditInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Information'),
      ),
      body: Center(
        child: Text(
          'Edit Information Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}