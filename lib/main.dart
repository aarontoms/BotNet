import 'package:flutter/material.dart';
import 'package:botnet/theme/theme.dart';
import 'dio_interceptor.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/forgot_password.dart';
import 'screens/home.dart';
import 'screens/search.dart';
import 'screens/profile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDio();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BotNet',
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => Home(),
        '/signup': (context) => SignUp(),
        '/forgot_password': (context) => Forgot(),
        '/home': (context) => Home(),
        '/search': (context) => Search(),
        '/profile': (context) => Profile(),
      },
      theme: AppTheme.themeData
    );
  }
}
