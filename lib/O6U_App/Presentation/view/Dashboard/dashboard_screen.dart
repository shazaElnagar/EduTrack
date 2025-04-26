import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

import '../Chats/chat_screen.dart';
import '../Monitoring/Monitoring_screen.dart';
import '../Settings/settings_screen.dart';

void main() {
  runApp(MyApp());
}

// Main App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      ),
      home: DashboardScreen(),
    );
  }
}

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
      backgroundColor: Colors.white,
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
          onPressed: () {},
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
            decoration: BoxDecoration(color: Colors.orange),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          buildDrawerItem('Notifications', Icons.notifications, () {}),
          buildDrawerItem('Attendance', Icons.check_circle, () {}),
          buildDrawerItem('Scan QR code', Icons.qr_code, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRViewExample()),
            );
          }),
          buildDrawerItem('Schedule', Icons.schedule, () {}),
          buildDrawerItem('Quiz Score', Icons.score, () {}),
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
        Text('Levels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 8),
        Row(
          children: List.generate(4, (index) {
            int batch = index + 1;
            return buildBatchButton(batch);
          }),
        ),
      ],
    );
  }

  Widget buildBatchButton(int batch) {
    bool isSelected = selectedBatch == batch;
    String label = batch == 1
        ? 'First'
        : batch == 2
        ? 'Second'
        : batch == 3
        ? 'Third'
        : 'Fourth';

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedBatch = batch;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$label batch',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
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
        Text('Subjects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              buildSubjectCard('Math-101', 'assets/math.jpg'),
              buildSubjectCard('PHY-102', 'assets/physics.jpg'),
              buildSubjectCard('CHEM-103', 'assets/chemistry.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSubjectCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {},
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
            Text(value, style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  Widget buildScanQRButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRViewExample()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.qr_code_scanner, size: 48, color: Colors.blue),
            SizedBox(height: 8),
            Text('Scan QR Now', style: TextStyle(color: Colors.blue, fontSize: 18)),
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
        if (index == 1) { // Settings is at index 3
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MonitoringScreen ()),
          );
        }

       else if (index == 2) { // Settings is at index 3
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatsScreen ()),
          );
        }
        else if (index == 3) { // Settings is at index 3
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        }

        },
        // You can also handle other tabs if you want here

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.monitor), label: 'Monitoring'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}

// QR Scan Screen
class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (qrText != null)
                  ? Text('Result: $qrText')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}