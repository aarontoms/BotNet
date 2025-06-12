import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BotNet',
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/signup': (context) => SignUp(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFC7C1D3), // Purplish accent
        brightness: Brightness.dark, // Use dark theme as a base
        surface: const Color(0xFF0C1417), // Match background for consistency
        onSurface: Colors.white, // Text color on background
        primary: const Color(0xFF3E4849), // Purplish accent for primary elements
        onPrimary: Colors.white, // Text color on primary elements
        ),
      ),
    );
  }
}
