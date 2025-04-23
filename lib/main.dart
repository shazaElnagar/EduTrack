import 'package:flutter/material.dart';
import 'O6U_App/Presentation/view/Authntaction/welcome_screen.dart';
import 'O6U_App/Presentation/view/Splash/splash.dart';
import 'O6U_App/Presentation/view/Authntaction/login_screen.dart';

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
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login' : (context) => const LoginScreen(),
      },
    );
  }
}