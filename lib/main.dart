import 'package:flutter/material.dart';
import 'O6U_App/Presentation/view/Authntaction/welcome_screen.dart';
import 'O6U_App/Presentation/view/Splash/splash.dart';
import 'O6U_App/Presentation/view/Authntaction/login_screen.dart';
import 'O6U_App/Presentation/view/Authntaction/sign_up_screen.dart';
import 'O6U_App/Presentation/view/Dashboard/dashboard_screen.dart';
import 'O6U_App/Presentation/view/Chats/chat_screen.dart';
import 'O6U_App/Presentation/view/Monitoring/Monitoring_screen.dart';
import 'O6U_App/Presentation/view/Settings/settings_screen.dart';
import 'O6U_App/Presentation/view/ScanQr/scan_screen.dart';
import 'O6U_App/Presentation/view/Schedule/schedle_screen.dart';
import 'O6U_App/Presentation/view/Notifications/notificatins_screen.dart';
import 'O6U_App/Presentation/view/Attendance/attendance_screen.dart';
import 'O6U_App/Presentation/view/QuizScore/quiz_score_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'O6U App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen(),
        '/welcome': (context) =>  WelcomeScreen(),
        '/login' : (context) =>  LoginScreen(),
        '/signup' :(context) =>  SignUpScreen(),
         '/home'  :(context) => DashboardScreen(),
        '/chats' : (context) => ChatsScreen(),
        '/monitoring' : (context) => MonitoringScreen(),
        '/settings' : (context) => SettingsScreen(),
        '/QrView' : (context) => QRViewExample(),
        '/Schedule' : (context) => ScheduleScreen(),
        '/notifications' : (context) => NotificationScreen(),
        '/Attendance' : (context) => AttendanceScreen(),
        '/Quiz Score' : (context) => QuizScorePage(),
      },
    );
  }
}