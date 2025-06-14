import 'package:flutter/material.dart';
import 'package:botnet/theme/theme.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/forgot_password.dart';

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
        '/forgot_password': (context) => Forgot(),
      },
      theme: AppTheme.themeData
    );
  }
}
