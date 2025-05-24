import 'package:flutter/material.dart';

import '../subjects/subject_screen.dart';


// Dashboard Screen
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedBatch = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: buildDrawer(),
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF005B7F),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text('TA', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF005B7F)),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          buildDrawerItem('Attendance', Icons.check_circle, () {
            Navigator.pushNamed(context, '/Attendance');
          }),
          buildDrawerItem('Schedule', Icons.schedule, () {
            Navigator.pushNamed(context, '/Schedule');

          }),
          buildDrawerItem('Quiz Score', Icons.score, () {
            Navigator.pushNamed(context, '/Quiz Score');
          }),
        ],
      ),
    );
  }

  ListTile buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          buildLevels(),
          SizedBox(height: 24),
          buildSubjects(),
          SizedBox(height: 24),
          buildRoleAndAcademicYear(),
          SizedBox(height: 24),
          buildScanQRButton(),
        ],
      ),
    );
  }

  Widget buildLevels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Levels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 8),
        Row(
          children: [
            buildBatchButton(1),
            buildBatchButton(2),
            buildBatchButton(3),
            buildBatchButton(4),
          ],
        )
      ],
    );
  }

  Widget buildBatchButton(int batch) {
    bool isSelected = selectedBatch == batch;
    String label = batch == 1
        ? 'First batch'
        : batch == 2
        ? 'Second batch'
        : batch == 3
        ? 'Third batch'
        : 'Fourth batch';

    return Flexible( 
      flex: 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedBatch = batch;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF005B7F) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildSubjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subjects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              buildSubjectCard('Math-101', 'assets/images/math1.png'),
              buildSubjectCard('CS-102', 'assets/images/computer.png'),
              buildSubjectCard('PHY-103', 'assets/images/physics.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSubjectCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanOptionsScreen(),
          ),
        );
        // Subject is now clickable — you can add logic here later
        print('Clicked on $title');
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          color: Colors.orange.withOpacity(0.8),
          child: Text(title, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget buildRoleAndAcademicYear() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildRoleCard('Role', 'TA', () {}),
        buildRoleCard('Academic Year', 'Spring - 2025', () {}),
      ],
    );
  }

  Widget buildRoleCard(String title, String value, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(color: Color(0xFF005B7F))),
          ],
        ),
      ),
    );
  }

  Widget buildScanQRButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/QrView');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF005B7F), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.qr_code_scanner, size: 50, color: Color(0xFF005B7F)),
            SizedBox(height: 8),
            Text('Scan QR Now', style: TextStyle(color: Color(0xFF005B7F), fontSize: 20,fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 1) {
          Navigator.pushNamed(context, '/monitoring');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/chats');
        } else if (index == 3) {
          Navigator.pushNamed(context, '/settings');
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.monitor), label: 'Monitoring'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}

